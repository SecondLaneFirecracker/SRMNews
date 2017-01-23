//
//  SRMNewsTopicNameListAdapter.m
//  SRMNews
//
//  Created by marksong on 23/01/2017.
//  Copyright © 2017 S.R. All rights reserved.
//

#import "SRMNewsTopicNameListAdapter.h"
#import "SRMTopicModel.h"

@implementation SRMNewsTopicNameListAdapter

- (NSArray<NSString *> *)transformFromOriginalData:(NSArray<SRMTopicModel *> *)originalData {
    NSMutableArray *topicNameList = [NSMutableArray array];
    
    [originalData enumerateObjectsUsingBlock:^(SRMTopicModel *topic, NSUInteger idx, BOOL * _Nonnull stop) {
        [topicNameList addObject:topic.name];
    }];
    
    return [topicNameList copy];
}

@end
