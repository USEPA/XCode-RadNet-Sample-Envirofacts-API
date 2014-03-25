//
//  ViewController.h
//  SampleEPA12
//
//  Created by Kevin Dunn on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppResultsData.h"

@interface ViewController : UIViewController <NSXMLParserDelegate, UITableViewDataSource>
{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    //---xml parsing---
    NSXMLParser *xmlParser;
 
    NSMutableArray *dataSet;
    AppResultsData *appResultsData;
    UITableView  *resultsTableView;
    UIToolbar *ToolBar;
    int Page;
    int ItemsPerPage;
    
}
@property (retain, nonatomic) IBOutlet UITableView *resultTableView;
@property (retain, nonatomic) IBOutlet UITextField *AnalyteField;
@property (retain, nonatomic) IBOutlet UIButton *QueryButton;
@property (retain, nonatomic) IBOutlet NSMutableString *soapResults;

@property (retain, nonatomic) IBOutlet UIToolbar *ToolBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *Prev;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *Next;

@property ( nonatomic) int Page;
@property ( nonatomic) int ItemsPerPage;

@property (strong, nonatomic) AppResultsData *appResultsData;
@property (nonatomic, retain) NSMutableArray *dataSet;
-(NSString *)buildURL:(NSString *)analyte;


@end
