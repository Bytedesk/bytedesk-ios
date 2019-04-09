//
//  FBImageViewCell.h
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017年 萝卜丝. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KFFormImageViewCellDelegate <NSObject>

- (void)pushImagePickerController;

- (void)presentViewController:(UIViewController *)vc;

@end

@interface KFFormImageViewCell : UITableViewCell

@property(nonatomic, weak) id<KFFormImageViewCellDelegate> delegate;

@property(nonatomic, strong) NSMutableArray *selectedPhotos;
@property(nonatomic, strong) NSMutableArray *selectedAssets;

@property(nonatomic, assign) BOOL            isSelectOriginalPhoto;


- (void)reloadCollectionData;


@end
