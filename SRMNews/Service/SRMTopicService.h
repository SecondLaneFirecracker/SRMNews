//
//  SRMTopicService.h
//  SRMNews
//
//  Created by marksong on 22/01/2017.
//  Copyright © 2017 S.R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRMTopicModel.h"

@interface SRMTopicService : NSObject

+ (instancetype)sharedInstance;
- (NSArray<SRMTopicModel *> *)getTopicList;
- (NSArray<NSString *> *)getTopicNameList;

@end
