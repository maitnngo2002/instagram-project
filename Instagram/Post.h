//
//  Post.h
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (Post *)createPost: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable ) caption;

@end

NS_ASSUME_NONNULL_END
