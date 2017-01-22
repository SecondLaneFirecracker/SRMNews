//
//  SRMBaseModel.h
//  SRMNews
//
//  Created by marksong on 22/01/2017.
//  Copyright © 2017 S.R. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SRMBaseModel : MTLModel <MTLJSONSerializing>

+ (id)modelfromJSONDictionary:(NSDictionary *)JSONDictionary;
+ (NSArray *)modelsfromJSONArray:(NSArray *)JSONArray;
- (NSDictionary *)JSONDictionary;
+ (NSArray *)JSONArrayFromModels:(NSArray *)models;

@end
