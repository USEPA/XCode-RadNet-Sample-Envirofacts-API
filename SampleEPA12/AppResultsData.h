//
//  AppResultsData.h
//  SampleEPA12
//
//  Created by Kevin Dunn on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppResultsData : NSObject
{
    NSString *ANA_NUM;
    NSString *RESULT_ID;
    NSString *ANALYTE_ID;
    NSString *RESULT_AMOUNT;
    NSString *CSU;
    NSString *MDC;
    NSString *RESULT_UNIT;
    NSString *RESULT_DATE;
    NSString *RESULT_IN_SI;
    NSString *CSU_IN_SI;
    NSString *MDC_IN_SI;
    NSString *SI_UNIT;
}

@property (nonatomic, retain) NSString *ANA_NUM;
@property (nonatomic, retain) NSString *RESULT_ID;
@property (nonatomic, retain) NSString *ANALYTE_ID;
@property (nonatomic, retain) NSString *RESULT_AMOUNT;

@property (nonatomic, retain) NSString *CSU;
@property (nonatomic, retain) NSString *MDC;
@property (nonatomic, retain) NSString *RESULT_UNIT;
@property (nonatomic, retain) NSString *RESULT_DATE;

@property (nonatomic, retain) NSString *RESULT_IN_SI;
@property (nonatomic, retain) NSString *CSU_IN_SI;
@property (nonatomic, retain) NSString *MDC_IN_SI;
@property (nonatomic, retain) NSString *SI_UNIT;
@end
