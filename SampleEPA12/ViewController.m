//
//  ViewController.m
//  SampleEPA12
//
//  Created by Kevin Dunn on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize AnalyteField;
@synthesize QueryButton;
@synthesize resultTableView;
@synthesize soapResults;
@synthesize appResultsData;
@synthesize dataSet;
@synthesize ToolBar;
@synthesize Prev;
@synthesize Next;
@synthesize Page;
@synthesize ItemsPerPage;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [QueryButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    //UIToolbar *toolBar = [[UIToolbar alloc] init];
    ToolBar.hidden=true;
    [self setPage:1];
    [self setItemsPerPage:10];
    
    
}
- (IBAction)nextAction:(id)sender {
    NSString *analytId = AnalyteField.text;
    [self setPage: Page+1];
    Prev.enabled=true;
    NSString *url=[self buildURL:analytId];
    [self getWebDataFromURL:url];
    //[AnalyteField resignFirstResponder];
    

}
- (IBAction)prevAction:(id)sender {
    NSString *analytId = AnalyteField.text;
    if(Page<=2){
        Prev.enabled=false;
        [self setPage: 1];
    }else{
        [self setPage: Page-1];
    }
    NSString *url=[self buildURL:analytId];
    [self getWebDataFromURL:url];
   // [AnalyteField resignFirstResponder];

}

-(void)buttonAction{
    NSString *analytId = AnalyteField.text;
    NSString *url=[self buildURL:analytId];
    [self getWebDataFromURL:url];
    [AnalyteField resignFirstResponder];
    Prev.enabled=false;
    
}


/**
 Some sample values are below
 Barium-140 =BA140
 Beryllium-7 =BE7
 Bismuth-212 =BI212
 Cesium-134 =CS134
 Cesium-136 =CS136
 Cesium-137 =CS137
 Cobalt-60 =CO60
 Iodine-131 =I131
 Iodine-132 =I132
 Lead-212 =PB212
 Lead-214 =PB214
 Plutonium-238 =PU238
 Plutonium-239 =PU239
 Potassium-40 =K40
 Radium-226 =RA226
 Radium-228 =RA228
 Uranium-234 =U234
 Uranium-235 =U235
 Uranium-238 =U238
 
 http://iaspub.epa.gov/enviro/erams_query_v2.simple_query
 **/

/*URL builder to epa site*/
-(NSString *)buildURL:(NSString *)analyteId{
    int startRow = (Page-1)*ItemsPerPage +1;
    int endRow = Page*ItemsPerPage;
    NSString *urlTemp = @"http://iaspub.epa.gov/enviro/efservice/ERM_RESULT/ANALYTE_ID/";
    
    urlTemp =[urlTemp stringByAppendingString:analyteId];
    urlTemp =[urlTemp stringByAppendingString:@"/rows/"];
     urlTemp =[urlTemp stringByAppendingString:[NSString stringWithFormat:@"%d", startRow]];
     urlTemp =[urlTemp stringByAppendingString:@":"];
    urlTemp =[urlTemp stringByAppendingString:[NSString stringWithFormat:@"%d", endRow]];
    NSLog(urlTemp);
    return urlTemp;
}


-(void) getWebDataFromURL:(NSString *)urlString{
    NSString *queryString =[NSString stringWithFormat: urlString];
    NSURL *url = [NSURL URLWithString:queryString]; 
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:0 forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"GET"];
    // [activityIndicator startAnimating];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [[NSMutableData data] retain];
        dataSet = [[NSMutableArray alloc] init];  
    }
}

/*Connection Code*/
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    NSLog(@"DONE. Received Bytes: %d", [webData length]);
    if([webData length]>0){
    if (xmlParser)
    {
        [xmlParser release];
    }
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    // Tell the UITableView to reload the data
    [self.resultTableView reloadData];
     //Tool Bar for Next 5
    ToolBar.hidden=false;
    }
    // Connection resources release.
    [connection release];
    [webData release];
    
   
}
-(void) connection:(NSURLConnection *) connection
didReceiveResponse:(NSURLResponse *) response {
    [webData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection
    didReceiveData:(NSData *) data {
    [webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error {
    [webData release];
    [connection release];
}


/*Parser Code*/
-(void) parser:(NSXMLParser *) parser didStartElement:
               (NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict 
{
    if( [elementName isEqualToString:@"ERM_RESULT"])
    {
        appResultsData = [[AppResultsData alloc] init];
        
    }
    //new tag new results
    [soapResults setString:@""];
}

-(void)parser:(NSXMLParser *)parser didEndElement:
             (NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{

    if ([elementName isEqualToString:@"ERM_RESULT"])
    {
        [dataSet addObject:appResultsData];
        [soapResults setString:@""];
        [appResultsData release];
        
    }
    if ([elementName isEqualToString:@"ANA_NUM"])
    {
        NSString *tmpstr = [[NSString alloc] init];
                  tmpstr = [tmpstr stringByAppendingString:soapResults];        
        [appResultsData setANA_NUM:tmpstr];
        [soapResults setString:@""];

        
    }
    if ([elementName isEqualToString:@"RESULT_ID"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults];  
        [appResultsData setRESULT_ID:tmpstr];
         
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"ANALYTE_ID"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setANALYTE_ID:tmpstr];
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"RESULT_AMOUNT"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setRESULT_AMOUNT:tmpstr];
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"CSU"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setCSU:tmpstr];
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"MDC"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setMDC:tmpstr];
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"RESULT_UNIT"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setRESULT_UNIT:tmpstr];
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"RESULT_DATE"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setRESULT_DATE:tmpstr];
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"RESULT_IN_SI"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setRESULT_IN_SI:tmpstr];
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"CSU_IN_SI"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setCSU_IN_SI:tmpstr];
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"MDC_IN_SI"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setMDC_IN_SI:tmpstr];
        [soapResults setString:@""];
        
    }
    if ([elementName isEqualToString:@"SI_UNIT"])
    {
        NSString *tmpstr = [[NSString alloc] init];
        tmpstr = [tmpstr stringByAppendingString:soapResults]; 
        [appResultsData setCSU_IN_SI:tmpstr];
        [soapResults setString:@""];
        
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (!soapResults) {
        // soapResults is an NSMutableString instance variable
        soapResults = [[NSMutableString alloc] init];
    }
    if([string length] > 0){
        NSString *cleanString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([cleanString length] >0){
        [soapResults appendString: string];
    }
   }
   
}

/*Table View Methods*/
#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    //NSLog(@"%s", __FUNCTION__);
    NSLog(@"self.dataSet count: %d", [self.dataSet count]);
    return [self.dataSet count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"cellForRow called");
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SimpleTableIdentifier];
    // UITableViewCell cell needs creating for this UITableView row.
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:SimpleTableIdentifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    if ([dataSet count] - 1 >= row)
    {
        // Create a object from the NSMutableArray appData
        AppResultsData *appResultsDataDisp = [dataSet objectAtIndex:row];
        // Compose a NSString to show UITableViewCell cell 
        NSString *rowText = [[NSString alloc ] initWithFormat:@"%@ - %@ - %@ - %@ - %@", appResultsDataDisp.RESULT_AMOUNT,appResultsDataDisp.CSU,appResultsDataDisp.MDC_IN_SI,appResultsDataDisp.RESULT_UNIT,appResultsData.RESULT_DATE];
        // Set UITableViewCell cell
        cell.textLabel.text = rowText;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        // Release alloc vars
        [rowText release];
    }
    return cell;
}

/*Little used view methods*/
//-(void) setUIState:(int)uiState;
//{
//    // Set view state to animating.
//    if (uiState == LOADING_STATE)
//    {
//        QueryButton.enabled = false;
//        QueryButton.alpha = 0.5f;
//        [activityIndicator startAnimating];
//        
//    }
//    // Set view state to not animating.
//    else if (uiState == ACTIVE_STATE)
//    {
//        QueryButton.enabled = true;
//        QueryButton.alpha = 1.0f;
//        [activityIndicator stopAnimating];
//    }
//}
- (void)viewDidUnload
{
    [self setAnalyteField:nil];
    [self setQueryButton:nil];
    [self setResultTableView:nil];
    [self setToolBar:nil];
    [self setToolBar:nil];
    [self setPrev:nil];
    [self setNext:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [AnalyteField release];
    [QueryButton release];
    [resultTableView release];
    [soapResults release];
    [appResultsData release];
    [dataSet release];

    [ToolBar release];
    [Prev release];
    [Next release];
    [super dealloc];
}
@end
