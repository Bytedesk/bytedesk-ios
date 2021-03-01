//
//  KFCoreTextView.m
//  KFCoreText
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "KFCoreTextView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#define SYSTEM_VERSION_LESS_THAN(v)	([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

NSString * const KFCoreTextTagDefault = @"_default";
NSString * const KFCoreTextTagImage = @"_image";
NSString * const KFCoreTextTagBullet = @"_bullet";
NSString * const KFCoreTextTagPage = @"_page";
NSString * const KFCoreTextTagLink = @"_link";

NSString * const KFCoreTextDataKey = @"key";
NSString * const KFCoreTextDataURL = @"url";
NSString * const KFCoreTextDataName = @"KFCoreTextDataName";
NSString * const KFCoreTextDataFrame = @"KFCoreTextDataFrame";
NSString * const KFCoreTextDataAttributes = @"KFCoreTextDataAttributes";

typedef enum {
	KFCoreTextTagTypeOpen,
	KFCoreTextTagTypeClose,
	KFCoreTextTagTypeSelfClose
} KFCoreTextTagType;

@interface KFCoreTextNode : NSObject

@property (nonatomic, assign) KFCoreTextNode	*supernode;
@property (nonatomic, retain) NSArray			*subnodes;
@property (nonatomic, copy)	  KFCoreTextStyle	*style;
@property (nonatomic, assign) NSRange			styleRange;
@property (nonatomic, assign) BOOL				isClosed;
@property (nonatomic, assign) NSInteger			startLocation;
@property (nonatomic, assign) BOOL				isLink;
@property (nonatomic, assign) BOOL				isImage;
@property (nonatomic, assign) BOOL				isBullet;
@property (nonatomic, retain) NSString			*imageName;

- (NSString *)descriptionOfTree;
- (NSString *)descriptionToRoot;
- (void)addSubnode:(KFCoreTextNode *)node;
- (void)adjustStylesAndSubstylesRangesByRange:(NSRange)insertedRange;
- (void)insertSubnode:(KFCoreTextNode *)subnode atIndex:(NSUInteger)index;
- (void)insertSubnode:(KFCoreTextNode *)subnode beforeNode:(KFCoreTextNode *)node;
- (KFCoreTextNode *)previousNode;
- (KFCoreTextNode *)nextNode;
- (NSUInteger)nodeIndex;
- (KFCoreTextNode *)subnodeAtIndex:(NSUInteger)index;

@end

@implementation KFCoreTextNode

@synthesize supernode = _supernode;
@synthesize subnodes = _subnodes;
@synthesize style = _style;
@synthesize styleRange = _styleRange;
@synthesize isClosed = _isClosed;
@synthesize isLink = _isLink;
@synthesize isImage = _isImage;
@synthesize startLocation = _startLocation;
@synthesize isBullet = _isBullet;
@synthesize imageName = _imageName;

- (NSArray *)subnodes
{
	if (_subnodes == nil) {
		_subnodes = [NSMutableArray new];
	}
	return _subnodes;
}

- (void)addSubnode:(KFCoreTextNode *)node
{
	[self insertSubnode:node atIndex:[_subnodes count]];
}

- (void)insertSubnode:(KFCoreTextNode *)subnode atIndex:(NSUInteger)index
{
	subnode.supernode = self;
	
	NSMutableArray *subnodes = (NSMutableArray *)self.subnodes;
	if (index <= [_subnodes count]) {
		[subnodes insertObject:subnode atIndex:index];
	}
	else {
		[subnodes addObject:subnode];
	}
}

- (void)insertSubnode:(KFCoreTextNode *)subnode beforeNode:(KFCoreTextNode *)node
{
	NSInteger existingNodeIndex = [_subnodes indexOfObject:node];
	if (existingNodeIndex == NSNotFound) {
		[self addSubnode:subnode];
	}
	else {
		[self insertSubnode:subnode atIndex:existingNodeIndex];
	}
}

- (NSInteger)numberOfParents
{
	NSInteger returnedValue = 0;
	KFCoreTextNode *node = self.supernode;
	while (node) {
		returnedValue++;
		node = node.supernode;
	}
	return returnedValue;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@\t-\t%@ - \t%@", [super description], _style.name, NSStringFromRange(_styleRange)];
}

- (NSString *)descriptionToRoot
{
	NSMutableString *description = [NSMutableString stringWithString:@"\n\n"];
	
	KFCoreTextNode *node = self;
	do {
		[description insertString:[NSString stringWithFormat:@"%@",[self description]] atIndex:0];
		
		for (int i = 0; i < [self numberOfParents]; i++) {
			[description insertString:@"\t" atIndex:0];
		}
		[description insertString:@"\n" atIndex:0];
		node = node.supernode;
		
	} while (node);
	
	return description;
}

- (NSString *)descriptionOfTree
{
	NSMutableString *description = [NSMutableString string];
	for (int i = 0; i < [self numberOfParents]; i++) {
		[description insertString:@"\t" atIndex:0];
	}
	[description appendFormat:@"%@\n", [self description]];
	for (KFCoreTextNode *node in _subnodes) {
		[description appendString:[node descriptionOfTree]];
	}
	return description;
}

- (NSArray *)_allSubnodes
{
	NSMutableArray *subnodes = [[NSMutableArray new] autorelease];
	for (KFCoreTextNode *node in _subnodes) {
		[subnodes addObject:node];
		if (node.subnodes) [subnodes addObjectsFromArray:[node _allSubnodes]];
	}
	
	return subnodes;
}

//return an array of nodes starting with the current and recursively adding all its child nodes
- (NSArray *)allSubnodes
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSArray *allSubnodes = [[self _allSubnodes] copy];
	[pool release];
	NSMutableArray *returnedArray = [NSMutableArray arrayWithObject:self];
	[returnedArray addObjectsFromArray:allSubnodes];
	[allSubnodes release];
	return returnedArray;
}

- (void)adjustStylesAndSubstylesRangesByRange:(NSRange)insertedRange
{
	NSRange range = self.styleRange;
	if (range.length + range.location > insertedRange.location) {
		range.location += insertedRange.length;
	}
	self.styleRange = range;
	
	for (KFCoreTextNode *node in _subnodes) {
		[node adjustStylesAndSubstylesRangesByRange:insertedRange];
	}
}

- (NSUInteger)nodeIndex
{
	return [_supernode.subnodes indexOfObject:self];
}

- (KFCoreTextNode *)subnodeAtIndex:(NSUInteger)index
{
	if (index < [_subnodes count]) {
		return [_subnodes objectAtIndex:index];
	}
	return nil;
}

- (KFCoreTextNode *)previousNode
{
	NSUInteger index = [self nodeIndex];
	if (index != NSNotFound) {
		return [_supernode subnodeAtIndex:index - 1];
	}
	return nil;
}

- (KFCoreTextNode *)nextNode
{
	NSUInteger index = [self nodeIndex];
	if (index != NSNotFound) {
		return [_supernode subnodeAtIndex:index + 1];
	}
	return nil;	
}

- (void)dealloc
{
	[_subnodes release];
	[_style release];
	[_imageName release];
	[super dealloc];
}

@end



@interface KFCoreTextView ()

@property (nonatomic, assign) CTFramesetterRef framesetter;
@property (nonatomic, retain) KFCoreTextNode *rootNode;

@property (nonatomic, strong) UIView         *highlightedSubView;

- (void)updateFramesetterIfNeeded;
- (void)processText;
CTFontRef CTFontCreateFromUIFont(UIFont *font);
- (BOOL)isSystemUnder3_2;
NSTextAlignment UITextAlignmentFromCoreTextAlignment(KFCoreTextAlignement alignment);
NSInteger rangeSort(NSString *range1, NSString *range2, void *context);
- (void)drawImages;
- (void)doInit;
- (void)didMakeChanges;
- (NSString *)defaultTagNameForKey:(NSString *)tagKey;
- (NSMutableArray *)divideTextInPages:(NSString *)string;

@end

@implementation KFCoreTextView

@synthesize text = _text;
@synthesize processedString = _processedString;
@synthesize path = _path;
@synthesize URLs = _URLs;
@synthesize URLDescriptions = _URLDescriptions;
@synthesize images = _images;
@synthesize delegate = _delegate;
@synthesize framesetter = _framesetter;
@synthesize rootNode = _rootNode;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize attributedString = _attributedString;
@synthesize highlightedSubView = _highlightedSubView;

#pragma mark - Tools methods

NSInteger rangeSort(NSString *range1, NSString *range2, void *context)
{
    NSRange r1 = NSRangeFromString(range1);
	NSRange r2 = NSRangeFromString(range2);
	
    if (r1.location < r2.location)
        return NSOrderedAscending;
    else if (r1.location > r2.location)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

CTFontRef CTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName, 
                                            font.pointSize, 
                                            NULL);
    return ctFont;
}

NSTextAlignment UITextAlignmentFromCoreTextAlignment(KFCoreTextAlignement alignment)
{
	switch (alignment) {
		case KFCoreTextAlignementCenter:
			return NSTextAlignmentCenter;
			break;
		case KFCoreTextAlignementRight:
			return NSTextAlignmentRight;
			break;			
		default:
			return NSTextAlignmentLeft;
			break;
	}
}

- (BOOL)isSystemUnder3_2
{
    static BOOL checked = NO;
    static BOOL systemUnder3_2;
    if (!checked) {
        checked = YES;
        systemUnder3_2 = SYSTEM_VERSION_LESS_THAN(@"3.2");
    }
	return systemUnder3_2;
}

#pragma mark - KFCoreTextView business
#pragma mark -

- (void)changeDefaultTag:(NSString *)coreTextTag toTag:(NSString *)newDefaultTag
{
	if ([_defaultsTags objectForKey:coreTextTag] == nil) {
		[NSException raise:NSInvalidArgumentException format:@"%@ is not a default tag of KFCoreTextView. Use the constant KFCoreTextTag constants.", coreTextTag];
	}
	else {
		[_defaultsTags setObject:newDefaultTag forKey:coreTextTag];
	}
}

- (NSString *)defaultTagNameForKey:(NSString *)tagKey
{
	return [_defaultsTags objectForKey:tagKey];
}

- (void)didMakeChanges
{
	_coreTextViewFlags.updatedAttrString = NO;
	_coreTextViewFlags.updatedFramesetter = NO;
}

#pragma mark - UI related

- (NSDictionary *)dataForPoint:(CGPoint)point
{
	NSMutableDictionary *returnedDict = [NSMutableDictionary dictionary];
	
	CGMutablePathRef mainPath = CGPathCreateMutable();
    if (!_path) {
        CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));  
    }
    else {
        CGPathAddPath(mainPath, NULL, _path);
    }
	
    CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
    CGPathRelease(mainPath);
	
    NSArray *lines = (NSArray *)CTFrameGetLines(ctframe);
    NSInteger lineCount = [lines count];
    CGPoint origins[lineCount];
    
    if (lineCount != 0) {
		
		CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
		
		for (int i = 0; i < lineCount; i++) {
			CGPoint baselineOrigin = origins[i];
			//the view is inverted, the y origin of the baseline is upside down
			baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
			
			CTLineRef line = (CTLineRef)[lines objectAtIndex:i];
			CGFloat ascent, descent;
			CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
			
			CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
			
			if (CGRectContainsPoint(lineFrame, point)) {
				//we look if the position of the touch is correct on the line
				
				CFIndex index = CTLineGetStringIndexForPosition(line, point);
				NSArray *urlsKeys = [_URLs allKeys];
				
				for (NSString *key in urlsKeys) {
					NSRange range = NSRangeFromString(key);
					if (index >= range.location && index < range.location + range.length) {
						NSURL *url = [_URLs objectForKey:key];
                        
                        [returnedDict setObject:[_URLDescriptions objectForKey:url] forKey:KFCoreTextDataKey];
                
						if (url) [returnedDict setObject:url forKey:KFCoreTextDataURL];
						break;
					}
				}
			
                //frame
                CFArrayRef runs = CTLineGetGlyphRuns(line);
                for(CFIndex j = 0; j < CFArrayGetCount(runs); j++) {
                    CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                    NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
                    
                    NSString *name = [attributes objectForKey:KFCoreTextDataName];
                    if (![name isEqualToString:@"_link"]) continue;
                    
                    [returnedDict setObject:attributes forKey:KFCoreTextDataAttributes];
                    
                    CGRect runBounds;
                    runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                    runBounds.size.height = ascent + descent;
                    
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                    runBounds.origin.x = baselineOrigin.x + self.frame.origin.x + xOffset + 0;
                    runBounds.origin.y = baselineOrigin.y + lineFrame.size.height - ascent;
                    
                    [returnedDict setObject:NSStringFromCGRect(runBounds) forKey:KFCoreTextDataFrame];
                    
                }
            
            }
			if (returnedDict.count > 0) break;
		}
	}
	
	CFRelease(ctframe);
	
	return returnedDict;
}


- (void)updateFramesetterIfNeeded
{
    if (!_coreTextViewFlags.updatedAttrString) {
		if (_framesetter != NULL) CFRelease(_framesetter);
		_framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
		_coreTextViewFlags.updatedAttrString = YES;
    }
}

/*!
 * @abstract get the supposed size of the drawn text
 *
 */

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size
{
	CGSize suggestedSize;
	if ([self isSystemUnder3_2]) {
		if (_processedString == nil) {
			[self processText];
		}
		KFCoreTextStyle *style = [_styles objectForKey:[self defaultTagNameForKey:KFCoreTextTagDefault]];
		suggestedSize = [_processedString sizeWithFont:style.font constrainedToSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
	}
	else {
		[self updateFramesetterIfNeeded];
		if (_framesetter == NULL) {
			return CGSizeZero;
		}
		suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, CFRangeMake(0, 0), NULL, size, NULL);
		suggestedSize = CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
	}
    return suggestedSize;
}

/*!
 * @abstract handy method to fit to the suggested height in one call
 *
 */

- (void)fitToSuggestedHeight
{
	CGSize suggestedSize = [self suggestedSizeConstrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
	CGRect viewFrame = self.frame;
	viewFrame.size.height = suggestedSize.height;
	self.frame = viewFrame;
}

#pragma mark - Text processing

/*!
 * @abstract remove the tags from the text and create a tree representation of the text
 *
 */

- (void)processText
{    
    if (!_text || [_text length] == 0) return;
	
	[_URLs removeAllObjects];
    [_URLDescriptions removeAllObjects];
    [_images removeAllObjects];
	
	KFCoreTextNode *rootNode = [[KFCoreTextNode new] autorelease];
	rootNode.style = [_styles objectForKey:[self defaultTagNameForKey:KFCoreTextTagDefault]];
	
	KFCoreTextNode *currentSupernode = rootNode;
	
	NSMutableString *processedString = [NSMutableString stringWithString:_text];
	
	BOOL finished = NO;
	NSRange remainingRange = NSMakeRange(0, [processedString length]);
	
	NSString *regEx = @"<(/){0,1}.*?( /){0,1}>";	
	
	BOOL systemUnder3_2 = ([self isSystemUnder3_2]);
	
	NSArray *possibleTags = nil;
	if (systemUnder3_2) {
		
		NSMutableArray *tagsNames = [NSMutableArray new];
		NSMutableArray *tags = [NSMutableArray new];
		for (KFCoreTextStyle *style in _styles.allValues) {
			[tagsNames addObject:style.name];
		}
		if (![tagsNames containsObject:KFCoreTextTagBullet]) [tagsNames addObject:KFCoreTextTagBullet];
		if (![tagsNames containsObject:KFCoreTextTagImage]) [tagsNames addObject:KFCoreTextTagImage];
		if (![tagsNames containsObject:KFCoreTextTagPage]) [tagsNames addObject:KFCoreTextTagPage];
		
		for (NSString *tagName in tagsNames) {
			[tags addObject:[NSString stringWithFormat:@"<%@>", tagName]];
			[tags addObject:[NSString stringWithFormat:@"</%@>", tagName]];
			[tags addObject:[NSString stringWithFormat:@"<%@ />", tagName]];
		}
		
		possibleTags = tags;
	}
	
	while (!finished) {
		
		NSRange tagRange;
		if (systemUnder3_2) {
			
			NSMutableArray *ranges = [NSMutableArray new];
			for (NSString *tag in possibleTags) {
				NSRange tagRange = [processedString rangeOfString:tag options:0 range:remainingRange];
				if (tagRange.location != NSNotFound) {
					[ranges addObject:NSStringFromRange(tagRange)];
				}
			}
			NSArray *sortedRanges = [ranges sortedArrayUsingFunction:rangeSort context:NULL];
			[ranges release];
			
			if (sortedRanges.count == 0) {
				tagRange.location = NSNotFound;
			}
			else {
				tagRange = NSRangeFromString([sortedRanges objectAtIndex:0]);
			}
		}
		else {
			tagRange = [processedString rangeOfString:regEx options:NSRegularExpressionSearch range:remainingRange];
		}
		
		if (tagRange.location == NSNotFound) {
			if (currentSupernode != rootNode && !currentSupernode.isClosed) {
//                DDLogInfo(@"KFCoreTextView :%@ - Couldn't parse text because tag '%@' at position %d is not closed - aborting rendering", self, currentSupernode.style.name, currentSupernode.startLocation);
				return;
			}
			finished = YES;
            continue;
		}
        
        NSString *fullTag = [processedString substringWithRange:tagRange];
        KFCoreTextTagType tagType;
        
        if ([fullTag rangeOfString:@"</"].location == 0) {
            tagType = KFCoreTextTagTypeClose;
        }
        else if ([fullTag rangeOfString:@"/>"].location == NSNotFound && [fullTag rangeOfString:@" />"].location == NSNotFound) {
            tagType = KFCoreTextTagTypeOpen;
        }
        else {
            tagType = KFCoreTextTagTypeSelfClose;
        }
        
		NSArray *tagsComponents = [fullTag componentsSeparatedByString:@" "];
		NSString *tagName = (tagsComponents.count > 0) ? [tagsComponents objectAtIndex:0] : fullTag;
        tagName = [tagName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< />"]];
		
        KFCoreTextStyle *style = [_styles objectForKey:tagName];
        
        if (style == nil) {
            style = [_styles objectForKey:[self defaultTagNameForKey:KFCoreTextTagDefault]];
//            DDLogWarn(@"KFCoreTextView :%@ - Couldn't find style for tag '%@'", self, tagName);
        }
        
        switch (tagType) {
            case KFCoreTextTagTypeOpen:
            {
                if (currentSupernode.isLink || currentSupernode.isImage) {
                    NSString *predefinedTag = nil;
                    if (currentSupernode.isLink) predefinedTag = [self defaultTagNameForKey:KFCoreTextTagLink];
                    else if (currentSupernode.isImage) predefinedTag = [self defaultTagNameForKey:KFCoreTextTagImage];
//                    DDLogWarn(@"KFCoreTextView :%@ - You can't open a new tag inside a '%@' tag - aborting rendering", self, predefinedTag);
                    return;
                }
                
                KFCoreTextNode *newNode = [KFCoreTextNode new];
                newNode.style = style;
                newNode.startLocation = tagRange.location;
                
                if ([tagName isEqualToString:[self defaultTagNameForKey:KFCoreTextTagLink]]) {
                    newNode.isLink = YES;
                }
                else if ([tagName isEqualToString:[self defaultTagNameForKey:KFCoreTextTagBullet]]) {
                    newNode.isBullet = YES;
                    
                    NSString *appendedString = [NSString stringWithFormat:@"%@\t", newNode.style.bulletCharacter];
                    
                    [processedString insertString:appendedString atIndex:tagRange.location + tagRange.length];
                    
                    //bullet styling
                    KFCoreTextStyle *bulletStyle = [KFCoreTextStyle new];
                    bulletStyle.name = @"_FTBulletStyle";
                    bulletStyle.font = newNode.style.bulletFont;
                    bulletStyle.color = newNode.style.bulletColor;
                    bulletStyle.applyParagraphStyling = NO;
                    bulletStyle.paragraphInset = UIEdgeInsetsMake(0, 0, 0, newNode.style.paragraphInset.left);
                    
                    KFCoreTextNode *bulletNode = [KFCoreTextNode new];
                    bulletNode.style = bulletStyle;
                    [bulletStyle release];
                    bulletNode.styleRange = NSMakeRange(tagRange.location, [appendedString length]);
                    
                    [newNode addSubnode:bulletNode];
                    [bulletNode release];
                }
                else if ([tagName isEqualToString:[self defaultTagNameForKey:KFCoreTextTagImage]]) {
                    newNode.isImage = YES;
                }
                
                [processedString replaceCharactersInRange:tagRange withString:@""];
                
                [currentSupernode addSubnode:newNode];
                [newNode release];
                
                currentSupernode = newNode;
                
                remainingRange.location = tagRange.location;
                remainingRange.length = [processedString length] - tagRange.location;
            }
                break;
            case KFCoreTextTagTypeClose:
            {
                if ((![currentSupernode.style.name isEqualToString:[self defaultTagNameForKey:KFCoreTextTagDefault]] && ![currentSupernode.style.name isEqualToString:tagName]) ) {
//                    DDLogWarn(@"KFCoreTextView :%@ - Closing tag '%@' at range %@ doesn't match open tag '%@' - aborting rendering", self, fullTag, NSStringFromRange(tagRange), currentSupernode.style.name);
                    return;
                }
                
                currentSupernode.isClosed = YES;
                
                if (currentSupernode.isLink) {
                    //replace active string with url text
                    
                    NSRange elementContentRange = NSMakeRange(currentSupernode.startLocation, tagRange.location - currentSupernode.startLocation);
                    NSString *elementContent = [processedString substringWithRange:elementContentRange];
                    NSRange pipeRange = [elementContent rangeOfString:@"|"];
                    NSString *urlString = nil;
                    NSString *urlDescription = nil;
                    if (pipeRange.location != NSNotFound) {
                        urlString = [elementContent substringToIndex:pipeRange.location];
                        urlDescription = [elementContent substringFromIndex:pipeRange.location + 1];
                    }
                    
                    [processedString replaceCharactersInRange:NSMakeRange(elementContentRange.location, elementContentRange.length + tagRange.length) withString:urlDescription];
//                    if (![urlString hasPrefix:@"http://"]) {
//                        urlString = [NSString stringWithFormat:@"http://%@", urlString];
//                    }
                    NSURL *url = [NSURL URLWithString:urlString];
                    NSRange urlDescriptionRange = NSMakeRange(elementContentRange.location, [urlDescription length]);
                    [_URLs setObject:url forKey:NSStringFromRange(urlDescriptionRange)];
                    [_URLDescriptions setObject:urlDescription forKey:url];
                    
                    currentSupernode.styleRange = urlDescriptionRange;
                }
                else if (currentSupernode.isImage) {
                    //replace active string with emptySpace
					
                    NSRange elementContentRange = NSMakeRange(currentSupernode.startLocation, tagRange.location - currentSupernode.startLocation);
                    NSString *elementContent = [processedString substringWithRange:elementContentRange];
                    
                    UIImage *img = [UIImage imageNamed:elementContent];
                    
                    if (img) {
                        NSString *lines = @"\n";
                        float leading = img.size.height;
                        currentSupernode.style.leading = leading;
                        
                        currentSupernode.imageName = elementContent;
                        [processedString replaceCharactersInRange:NSMakeRange(elementContentRange.location, elementContentRange.length + tagRange.length) withString:lines];
                        
                        [_images addObject:currentSupernode];
                        currentSupernode.styleRange = NSMakeRange(elementContentRange.location, [lines length]);
						
                    }
                    else {
                        //NSLog(@"KFCoreTextView :%@ - Couldn't find image '%@' in main bundle", self, elementContentRange);
                        [processedString replaceCharactersInRange:tagRange withString:@""];
                    }
                }
                else {
                    currentSupernode.styleRange = NSMakeRange(currentSupernode.startLocation, tagRange.location - currentSupernode.startLocation);
                    [processedString replaceCharactersInRange:tagRange withString:@""];
                }
                
                if ([currentSupernode.style.appendedCharacter length] > 0) {
                    [processedString insertString:currentSupernode.style.appendedCharacter atIndex:currentSupernode.styleRange.location + currentSupernode.styleRange.length];
                    NSRange newStyleRange = currentSupernode.styleRange;
                    newStyleRange.length += [currentSupernode.style.appendedCharacter length];
                    currentSupernode.styleRange = newStyleRange;							
                }
                
                if (style.paragraphInset.top > 0) {
                    if (![style.name isEqualToString:[self defaultTagNameForKey:KFCoreTextTagBullet]] ||  [[currentSupernode previousNode].style.name isEqualToString:[self defaultTagNameForKey:KFCoreTextTagBullet]]) {
                        
                        //fix: add a new line for each new line and set its height to 'top' value
                        [processedString insertString:@"\n" atIndex:currentSupernode.startLocation];
                        NSRange topSpacingStyleRange = NSMakeRange(currentSupernode.startLocation, [@"\n" length]);
                        KFCoreTextStyle *topSpacingStyle = [[KFCoreTextStyle alloc] init];
                        topSpacingStyle.name = [NSString stringWithFormat:@"_FTTopSpacingStyle_%@", currentSupernode.style.name];
                        topSpacingStyle.minLineHeight = currentSupernode.style.paragraphInset.top;
                        topSpacingStyle.maxLineHeight = currentSupernode.style.paragraphInset.top;
                        KFCoreTextNode *topSpacingNode = [[KFCoreTextNode alloc] init];
                        topSpacingNode.style = topSpacingStyle;
                        [topSpacingStyle release];
                        
                        topSpacingNode.styleRange = topSpacingStyleRange;
                        
                        [currentSupernode.supernode insertSubnode:topSpacingNode beforeNode:currentSupernode];
                        [topSpacingNode release];
                        
                        [currentSupernode adjustStylesAndSubstylesRangesByRange:topSpacingStyleRange];
                    }
                }
                
                remainingRange.location = currentSupernode.styleRange.location + currentSupernode.styleRange.length;
                remainingRange.length = [processedString length] - remainingRange.location;
                
                currentSupernode = currentSupernode.supernode;
            }
                break;
            case KFCoreTextTagTypeSelfClose:
            {
                KFCoreTextNode *newNode = [KFCoreTextNode new];
                newNode.style = style;
                [processedString replaceCharactersInRange:tagRange withString:newNode.style.appendedCharacter];
                newNode.styleRange = NSMakeRange(tagRange.location, [newNode.style.appendedCharacter length]);
                [currentSupernode addSubnode:newNode];	
                [newNode release];
                
                remainingRange.location = tagRange.location;
                remainingRange.length = [processedString length] - tagRange.location;
            }
                break;
        }
	}	
	
	rootNode.styleRange = NSMakeRange(0, [processedString length]);
	
	self.rootNode = rootNode;	
	self.processedString = processedString;
}

/*!
 * @abstract Remove all the tags and return a clean text to be used
 *
 */

+ (NSString *)stripTagsForString:(NSString *)string
{
    KFCoreTextView *instance = [[KFCoreTextView alloc] initWithFrame:CGRectZero];
    [instance setText:string];
    [instance processText];
    NSString *result = [[instance.processedString copy] autorelease];
    [instance release];
    return result;
}

/*!
 * @abstract divide the text in different pages according to the tags <_page/> found
 *
 */

+ (NSArray *)pagesFromText:(NSString *)string
{
    KFCoreTextView *instance = [[KFCoreTextView alloc] initWithFrame:CGRectZero];
    NSArray *result = [instance divideTextInPages:string];
	[instance release];
    return (NSArray *)result;
}

/*!
 * @abstract divide the text in different pages according to the tags <_page/> found
 *
 */

- (NSMutableArray *)divideTextInPages:(NSString *)string
{
    NSMutableArray *result = [NSMutableArray array];
    int prevStart = 0;
    while (YES) {
        NSRange rangeStart = [string rangeOfString:[NSString stringWithFormat:@"<%@/>", [self defaultTagNameForKey:KFCoreTextTagPage]]];
		if (rangeStart.location == NSNotFound) rangeStart = [string rangeOfString:[NSString stringWithFormat:@"<%@ />", [self defaultTagNameForKey:KFCoreTextTagPage]]];
		
        if (rangeStart.location != NSNotFound) {
            NSString *page = [string substringWithRange:NSMakeRange(prevStart, rangeStart.location)];
            [result addObject:page];
            string = [string stringByReplacingCharactersInRange:rangeStart withString:@""];
            prevStart = rangeStart.location;
        }
        else {
            NSString *page = [string substringWithRange:NSMakeRange(prevStart, (string.length - prevStart))];
            [result addObject:page];
            break;
        }
    }
    return result;
}

#pragma mark Styling

- (void)addStyle:(KFCoreTextStyle *)style
{
    [_styles setValue:style forKey:style.name];
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)addStyles:(NSArray *)styles
{
	for (KFCoreTextStyle *style in styles) {
		[_styles setValue:style forKey:style.name];
	}
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)removeAllStyles
{
	[_styles removeAllObjects];
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)applyStyle:(KFCoreTextStyle *)style inRange:(NSRange)styleRange onString:(NSMutableAttributedString **)attributedString
{
    [*attributedString addAttribute:(id)KFCoreTextDataName
							  value:(id)style.name
							  range:styleRange];
    
	[*attributedString addAttribute:(id)kCTForegroundColorAttributeName
							  value:(id)style.color.CGColor
							  range:styleRange];
	
	if (style.isUnderLined) {
		NSNumber *underline = [NSNumber numberWithInt:kCTUnderlineStyleSingle];
		[*attributedString addAttribute:(id)kCTUnderlineStyleAttributeName
								  value:(id)underline
								  range:styleRange];
	}	
	
	CTFontRef ctFont = CTFontCreateFromUIFont(style.font);
	
	[*attributedString addAttribute:(id)kCTFontAttributeName
							  value:(id)ctFont
							  range:styleRange];
	CFRelease(ctFont);
	
	CTTextAlignment alignment = style.textAlignment;
	CGFloat maxLineHeight = style.maxLineHeight;
	CGFloat minLineHeight = style.minLineHeight;
	CGFloat paragraphLeading = style.leading;
	
	CGFloat paragraphSpacingBefore = style.paragraphInset.top;
	CGFloat paragraphSpacingAfter = style.paragraphInset.bottom;
	CGFloat paragraphFirstLineHeadIntent = style.paragraphInset.left;
	CGFloat paragraphHeadIntent = style.paragraphInset.left;
	CGFloat paragraphTailIntent = style.paragraphInset.right;
	
	//if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
	paragraphSpacingBefore = 0;
	//}
	
	CFIndex numberOfSettings = 9;
	CGFloat tabSpacing = 28.f;
	
	BOOL applyParagraphStyling = style.applyParagraphStyling;
	
	if ([style.name isEqualToString:[self defaultTagNameForKey:KFCoreTextTagBullet]]) {
		applyParagraphStyling = YES;
	}
	else if ([style.name isEqualToString:@"_FTBulletStyle"]) {
		applyParagraphStyling = YES;
		numberOfSettings++;
		tabSpacing = style.paragraphInset.right;
		paragraphSpacingBefore = 0;
		paragraphSpacingAfter = 0;
		paragraphFirstLineHeadIntent = 0;
		paragraphTailIntent = 0;
	}
	else if ([style.name hasPrefix:@"_FTTopSpacingStyle"]) {
		[*attributedString removeAttribute:(id)kCTParagraphStyleAttributeName range:styleRange];
	}
	
	if (applyParagraphStyling) {
		
		CTTextTabRef tabArray[] = { CTTextTabCreate(0, tabSpacing, NULL) };
		
		CFArrayRef tabStops = CFArrayCreate( kCFAllocatorDefault, (const void**) tabArray, 1, &kCFTypeArrayCallBacks );
		CFRelease(tabArray[0]);
		
		CTParagraphStyleSetting settings[] = {
			{kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
			{kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
			{kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight},
			{kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
			{kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacingAfter},
			{kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &paragraphFirstLineHeadIntent},
			{kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &paragraphHeadIntent},
			{kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &paragraphTailIntent},
			{kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &paragraphLeading},
			{kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStops}//always at the end
		};
		
		CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, numberOfSettings);
		[*attributedString addAttribute:(id)kCTParagraphStyleAttributeName
								  value:(id)paragraphStyle 
								  range:styleRange];
		CFRelease(tabStops);
		CFRelease(paragraphStyle);
	}
}

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andAttributedString:nil];
}

- (id)initWithFrame:(CGRect)frame andAttributedString:(NSAttributedString *)attributedString
{
	self = [super initWithFrame:frame];
	if (self) {
		_attributedString = [attributedString retain];
		[self doInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
	// Initialization code
	_framesetter = NULL;
	_styles = [[NSMutableDictionary alloc] init];
	_URLs = [[NSMutableDictionary alloc] init];
    _URLDescriptions = [[NSMutableDictionary alloc] init];
    _images = [[NSMutableArray alloc] init];
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.contentMode = UIViewContentModeRedraw;
	[self setUserInteractionEnabled:YES];
	
	KFCoreTextStyle *defaultStyle = [KFCoreTextStyle styleWithName:KFCoreTextTagDefault];
    defaultStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:14.f];
    defaultStyle.textAlignment = KFCoreTextAlignementJustified;
	[self addStyle:defaultStyle];
	
	KFCoreTextStyle *linksStyle = [defaultStyle copy];
	linksStyle.color = [UIColor blueColor];
	linksStyle.name = KFCoreTextTagLink;
	[_styles setValue:linksStyle forKey:linksStyle.name];
	[linksStyle release];
	
	_defaultsTags = [[NSMutableDictionary dictionaryWithObjectsAndKeys:KFCoreTextTagDefault, KFCoreTextTagDefault,
					  KFCoreTextTagLink, KFCoreTextTagLink,
					  KFCoreTextTagImage, KFCoreTextTagImage,
					  KFCoreTextTagPage, KFCoreTextTagPage,
					  KFCoreTextTagBullet, KFCoreTextTagBullet,
					  nil] retain];
}

- (void)dealloc
{
	if (_framesetter) CFRelease(_framesetter);
	if (_path) CGPathRelease(_path);
	[_rootNode release];
    [_text release];
    [_styles release];
    [_processedString release];
    [_URLs release];
    [_URLDescriptions release];
    [_images release];
	[_shadowColor release];
	[_attributedString release];
	[_defaultsTags release];
    [super dealloc];
}

#pragma mark - Custom Setters

- (void)setText:(NSString *)text
{
    [_text release];
    _text = [text retain];
	_coreTextViewFlags.textChangesMade = YES;
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

//only here to assure compatibility with previous versions
- (void)setStyles:(NSDictionary *)styles
{
	[_styles release];
    _styles = [styles mutableCopy];
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)setPath:(CGPathRef)path
{
    _path = CGPathRetain(path);
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)setShadowColor:(UIColor *)shadowColor
{
	[_shadowColor release];
	_shadowColor = [shadowColor retain];
	if ([self superview]) [self setNeedsDisplay];
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
	_shadowOffset = shadowOffset;
	if ([self superview]) [self setNeedsDisplay];
}

#pragma mark - Custom Getters

//only here to assure compatibility with previous versions
- (NSArray *)stylesArray {
	return [self styles];
}

- (NSArray *)styles {
	return [_styles allValues];
}

- (NSAttributedString *)attributedString {
	if (!_coreTextViewFlags.updatedAttrString) {
		_coreTextViewFlags.updatedAttrString = YES;
		
		if (_processedString == nil || _coreTextViewFlags.textChangesMade) {
			_coreTextViewFlags.textChangesMade = NO;
			[self processText];
		}
		
		if (_processedString) {
			
			NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_processedString];
			
			for (KFCoreTextNode *node in [_rootNode allSubnodes]) {
				[self applyStyle:node.style inRange:node.styleRange onString:&string];
			}
			
			[_attributedString release];
			_attributedString = string;
		}
	}
	return _attributedString;
}

#pragma mark - View lifecycle

/*!
 * @abstract draw the actual coretext on the context
 */
- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self.backgroundColor setFill];
	CGContextFillRect(context, rect);
	
	if ([self isSystemUnder3_2]) {
		
		if (_processedString == nil || _coreTextViewFlags.textChangesMade) {
			_coreTextViewFlags.textChangesMade = NO;
			[self processText];
		}
		
		if (_shadowColor) {
			CGContextSetShadowWithColor(context, _shadowOffset, 0.f, _shadowColor.CGColor);
		}
		
		KFCoreTextStyle *defaultStyle = [_styles objectForKey:[self defaultTagNameForKey:KFCoreTextTagDefault]];
		[defaultStyle.color setFill];
		[_processedString drawInRect:rect
							withFont:defaultStyle.font
					   lineBreakMode:UILineBreakModeWordWrap
						   alignment:UITextAlignmentFromCoreTextAlignment(defaultStyle.textAlignment)];
	}
	else {
		[self updateFramesetterIfNeeded];
		
		CGMutablePathRef mainPath = CGPathCreateMutable();
		
		if (!_path) {
			CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));  
		}
		else {
			CGPathAddPath(mainPath, NULL, _path);
		}
		
		CTFrameRef drawFrame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
		
		if (drawFrame == NULL) {
//            DDLogInfo(@"KFCoreText unable to render: %@", self.processedString);
		}
		else {
			//draw images
			if ([_images count] > 0) [self drawImages];
			
			if (_shadowColor) {
				CGContextSetShadowWithColor(context, _shadowOffset, 0.f, _shadowColor.CGColor);
			}
			
			CGContextSetTextMatrix(context, CGAffineTransformIdentity);
			CGContextTranslateCTM(context, 0, self.bounds.size.height);
			CGContextScaleCTM(context, 1.0, -1.0);
			// draw text
			CTFrameDraw(drawFrame, context);
		}
		// cleanup
		if (drawFrame) CFRelease(drawFrame);
		CGPathRelease(mainPath);
	}
}

- (void)drawImages {
    
	CGMutablePathRef mainPath = CGPathCreateMutable();
    if (!_path) {
        CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));  
    }
    else {
        CGPathAddPath(mainPath, NULL, _path);
    }
	
    CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
    CGPathRelease(mainPath);
	
    NSArray *lines = (NSArray *)CTFrameGetLines(ctframe);
    NSInteger lineCount = [lines count];
    CGPoint origins[lineCount];
	
	CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
	
	KFCoreTextNode *imageNode = [_images objectAtIndex:0];
	
	for (int i = 0; i < lineCount; i++) {
		CGPoint baselineOrigin = origins[i];
		//the view is inverted, the y origin of the baseline is upside down
		baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
		
		CTLineRef line = (CTLineRef)[lines objectAtIndex:i];
		CFRange cfrange = CTLineGetStringRange(line);        
		
        if (cfrange.location > imageNode.styleRange.location) {
			CGFloat ascent, descent;
			CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
			
			CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
			
			CTTextAlignment alignment = imageNode.style.textAlignment;
			
			UIImage *img = [UIImage imageNamed:imageNode.imageName];
			if (img) {
				int x = 0;
				if (alignment == kCTRightTextAlignment) x = (self.frame.size.width - img.size.width);
				if (alignment == kCTCenterTextAlignment) x = ((self.frame.size.width - img.size.width) / 2);
				
				CGRect frame = CGRectMake(x, (lineFrame.origin.y - img.size.height), img.size.width, img.size.height);
                
                // adjusting frame
				
                UIEdgeInsets insets = imageNode.style.paragraphInset;
                if (alignment != kCTCenterTextAlignment) frame.origin.x = (alignment == kCTLeftTextAlignment)? insets.left : (self.frame.size.width - img.size.width - insets.right);
                frame.origin.y += insets.top;
                frame.size.width = ((insets.left + insets.right + img.size.width ) > self.frame.size.width)? self.frame.size.width : img.size.width;
                
				[img drawInRect:CGRectIntegral(frame)];
			}
			
			NSInteger imageNodeIndex = [_images indexOfObject:imageNode];
			if (imageNodeIndex < [_images count] - 1) {
				imageNode = [_images objectAtIndex:imageNodeIndex + 1];
			}
			else {
				break;
			}
		}
	}
	CFRelease(ctframe);
}

#pragma mark User Interaction

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
    NSDictionary *data = [self dataForPoint:point];
    
    CGRect frame = CGRectFromString([data objectForKey:KFCoreTextDataFrame]);
    
    if (CGRectEqualToRect(CGRectZero, frame)) return;
    
    frame.origin.x -= 3;
    frame.origin.y -= 10;
    frame.size.width += 6;
    frame.size.height += 6;
    _highlightedSubView = [[UIView alloc] initWithFrame:frame];
    [_highlightedSubView.layer setCornerRadius:3];
    //[_highlightedSubView setBackgroundColor:[UIColor colorWithRed:0.112 green:0.000 blue:0.791 alpha:1.000]];
    [_highlightedSubView setAlpha:0];
    
    [self.superview addSubview:_highlightedSubView];
    
    [_highlightedSubView setAlpha:0.4];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

// FIXME: 未调用？修改为touchesCancelled执行回调
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
	
//    [_highlightedSubView removeFromSuperview];
//    if (![self isSystemUnder3_2]) {
//        if (self.delegate && ([self.delegate respondsToSelector:@selector(touchedData:inCoreTextView:)]
//                              || [self.delegate respondsToSelector:@selector(coreTextView:receivedTouchOnData:)])) {
//            CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
//            NSDictionary *data = [self dataForPoint:point];
//            if (data) {
//                if ([self.delegate respondsToSelector:@selector(coreTextView:receivedTouchOnData:)]) {
//                    [self.delegate coreTextView:self receivedTouchOnData:data];
//                }
//                else {
//                    if ([self.delegate respondsToSelector:@selector(touchedData:inCoreTextView:)]) {
//                        [self.delegate touchedData:data inCoreTextView:self];
//                    }
//                }
//            }
//        }
//    } else {
//        DDLogInfo(@"isSystemUnder3_2 cant touch data");
//    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [_highlightedSubView removeFromSuperview];
    
    if (![self isSystemUnder3_2]) {
        if (self.delegate && ([self.delegate respondsToSelector:@selector(touchedData:inCoreTextView:)]
                              || [self.delegate respondsToSelector:@selector(coreTextView:receivedTouchOnData:)])) {
            CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
            NSDictionary *data = [self dataForPoint:point];
            if (data) {
                if ([self.delegate respondsToSelector:@selector(coreTextView:receivedTouchOnData:)]) {
                    [self.delegate coreTextView:self receivedTouchOnData:data];
                }
            }
        }
    }
}

@end

@implementation NSString (KFCoreText)

- (NSString *)stringByAppendingTagName:(NSString *)tagName
{
	return [NSString stringWithFormat:@"<%@>%@</%@>", tagName, self, tagName];
}

@end
