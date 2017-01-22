//
//  SRMBaseModel.m
//  SRMNews
//
//  Created by marksong on 22/01/2017.
//  Copyright © 2017 S.R. All rights reserved.
//

#import "SRMBaseModel.h"

@implementation SRMBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary dictionary];
}

+ (id)modelfromJSONDictionary:(NSDictionary *)JSONDictionary {
    NSError *error;
    id model = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:JSONDictionary error:&error];
    
    if (error) {
        NSLog(@"Generate model %@ from dictionary: %@\nwith error: %@", self.class, JSONDictionary, error);
    }
    
    return model;
}

+ (NSArray *)modelsfromJSONArray:(NSArray *)JSONArray {
    NSError *error;
    NSArray *models = [MTLJSONAdapter modelsOfClass:self.class fromJSONArray:JSONArray error:&error];
    
    if (error) {
        NSLog(@"Generate array of model %@ from json array: %@\nwith error: %@", self.class, JSONArray, error);
    }
    
    return models;
}

- (NSDictionary *)JSONDictionary {
    NSError *error;
    NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:self error:&error];
    
    if (error) {
        NSLog(@"Generate dictionary from model: %@\nwith error: %@", self, error);
    }
    
    return JSONDictionary;
}

+ (NSArray *)JSONArrayFromModels:(NSArray *)models {
    NSError *error;
    NSArray *JSONArray = [MTLJSONAdapter JSONArrayFromModels:models error:&error];
    
    if (error) {
        NSLog(@"Generate JSON array from models: %@\nwith error: %@", models, error);
    }
    
    return JSONArray;
}

@end
