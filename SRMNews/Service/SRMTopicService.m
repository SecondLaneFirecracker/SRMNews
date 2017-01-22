//
//  SRMTopicService.m
//  SRMNews
//
//  Created by marksong on 22/01/2017.
//  Copyright © 2017 S.R. All rights reserved.
//

#import "SRMTopicService.h"

@interface SRMTopicService ()

@property (nonatomic) NSArray<SRMTopicModel *> * topicList;

@end

@implementation SRMTopicService

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self class] new];
    });
    
    return sharedInstance;
}

- (NSArray<SRMTopicModel *> *)getTopicList {
    if (!self.topicList) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"news_topic" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.topicList = [SRMTopicModel modelsfromJSONArray:dataDictionary[@"tList"]];
    }
    
    return self.topicList;
}

- (NSArray<NSString *> *)getTopicNameList {
    NSMutableArray *topicNameList = [NSMutableArray array];
    
    [self.topicList enumerateObjectsUsingBlock:^(SRMTopicModel *topic, NSUInteger idx, BOOL * _Nonnull stop) {
        [topicNameList addObject:topic.name];
    }];
    
    return [topicNameList copy];
}

@end
