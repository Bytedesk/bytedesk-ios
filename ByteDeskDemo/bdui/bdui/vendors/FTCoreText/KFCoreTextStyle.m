//
//  KFCoreTextStyle.m
//  KFCoreText
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "KFCoreTextStyle.h"

@implementation KFCoreTextStyle

@synthesize name = _name;
@synthesize appendedCharacter = _appendedCharacter;
@synthesize font = _font;
@synthesize color = _color;
@synthesize underlined = _underlined;
@synthesize textAlignment = _textAlignment;
@synthesize paragraphInset = _paragraphInset;
@synthesize applyParagraphStyling = _applyParagraphStyling;
@synthesize bulletCharacter = _bulletCharacter;
@synthesize bulletFont = _bulletFont;
@synthesize bulletColor = _bulletColor;
@synthesize leading = _leading;
@synthesize maxLineHeight = _maxLineHeight;
@synthesize minLineHeight = _minLineHeight;
@synthesize spaceBetweenParagraphs = _spaceBetweenParagraphs;

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"_default";
		self.bulletCharacter = @"•";
		self.appendedCharacter = @"";
		self.font = [UIFont systemFontOfSize:12];
		self.color = [UIColor blackColor];
		self.underlined = NO;
		self.textAlignment = KFCoreTextAlignementLeft;
		self.maxLineHeight = 0;
		self.minLineHeight = 0;
		self.paragraphInset = UIEdgeInsetsZero;
		self.applyParagraphStyling = YES;
		self.leading = 0;
	}
	return self;
}

+ (id)styleWithName:(NSString *)name {
    KFCoreTextStyle *style = [[KFCoreTextStyle alloc] init];
    [style setName:name];
    return [style autorelease];
}

- (void)setSpaceBetweenParagraphs:(CGFloat)spaceBetweenParagraphs
{
	UIEdgeInsets edgeInset = _paragraphInset;
	edgeInset.bottom = spaceBetweenParagraphs;
	self.paragraphInset = edgeInset;
}

- (CGFloat)spaceBetweenParagraphs
{
	return _paragraphInset.bottom;
}

- (UIFont *)bulletFont
{
	if (_bulletFont == nil) {
		return _font;
	}
	return _bulletFont;
}

- (UIColor *)bulletColor
{
	if (_bulletColor == nil) {
		return _color;
	}
	return _bulletColor;
}

- (id)copyWithZone:(NSZone *)zone
{
	KFCoreTextStyle *style = [[KFCoreTextStyle alloc] init];
	style.name = [[self.name copy] autorelease];
	style.bulletCharacter = self.bulletCharacter;
	style.appendedCharacter = [[self.appendedCharacter copy] autorelease];
	style.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
	style.color = self.color;
	style.underlined = self.isUnderLined;
    style.textAlignment = self.textAlignment;
	style.maxLineHeight = self.maxLineHeight;
	style.minLineHeight = self.minLineHeight;
	style.paragraphInset = self.paragraphInset;
	style.applyParagraphStyling = self.applyParagraphStyling;
	style.leading = self.leading;
	return style;
}

- (void)setParagraphInset:(UIEdgeInsets)paragraphInset
{
	_paragraphInset = paragraphInset;
}

- (void)dealloc
{    
    [_name release];
	[_bulletCharacter release];
    [_appendedCharacter release];
    [_font release];
    [_color release];
	[_bulletColor release];
	[_bulletFont release];
    [super dealloc];
}

#pragma GCC diagnostic warning "-Wdeprecated-declarations"

@end
