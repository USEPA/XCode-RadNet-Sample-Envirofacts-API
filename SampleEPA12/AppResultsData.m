//
//  AppResultsData.m
//  SampleEPA12
//
//  Created by Kevin Dunn on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppResultsData.h"

@implementation AppResultsData

@synthesize      ANA_NUM,RESULT_ID,ANALYTE_ID,RESULT_AMOUNT,
                 CSU,MDC,RESULT_UNIT,RESULT_DATE,RESULT_IN_SI,
                 CSU_IN_SI,MDC_IN_SI,SI_UNIT;

-(id) init{
    [super init];
    return self;
}

-(void) dealloc
{
    [self setANA_NUM:nil];
    [self setRESULT_ID:nil];
    [self setANALYTE_ID:nil];
    [self setRESULT_AMOUNT:nil];
    [self setCSU:nil];
    [self setMDC:nil];
    [self setRESULT_UNIT:nil];
    [self setRESULT_DATE:nil];
    [self setRESULT_IN_SI:nil];
    [self setCSU_IN_SI:nil];
    [self setMDC_IN_SI:nil];
    [self setSI_UNIT:nil];
}


@end
