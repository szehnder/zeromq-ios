//
//  ZeroMQ_Monitor_IOSViewController.m
//  ZeroMQ Monitor IOS
//
//  Created by Sean Zehnder on 10/8/11.
//  Copyright 2011 seanzehnder.com. All rights reserved.
//

#import "ZeroMQ_Monitor_IOSViewController.h"
#import "MeepsZMQ.h"
//#import "ChatMessage.pb.h"

@implementation ZeroMQ_Monitor_IOSViewController
//@synthesize messageInputField;
@synthesize messages;
@synthesize mainTableView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MeepsZMQ instance];
    self.messages = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChatMessageReceived:) name:@"ChatMessageReceived" object:nil];
	
}

-(void) handleChatMessageReceived:(NSNotification*)note {
    NSString *msg = [note object];
    [self.messages addObject:msg];
    [self.mainTableView reloadData];
//    [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
//    [self performSelector:(@selector(refreshDisplay:)) withObject:(self.mainTableView) afterDelay:0.5];
}

- (void)refreshDisplay:(UITableView *)myTableView {
    [myTableView reloadData]; 
}

- (void)viewDidUnload
{
//    [self setMessageInputField:nil];
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


-(IBAction) sendMessageClicked:(id)sender {
    
}

-(IBAction) showSettingsClicked:(id)sender {
    
}

-(IBAction) hideSettingsClicked:(id)sender {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; //initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
//    ChatMessage *msg = [messages objectAtIndex:indexPath.row];
//    NSString *lab = [NSString stringWithFormat:@"[%@] %@", msg.topic, msg.body];
    NSDictionary *lab = [messages objectAtIndex:indexPath.row]; 
    NSString *cellValue = [[NSString alloc] initWithFormat:@"[%@] %@", [lab objectForKey:@"topic"], [lab objectForKey:@"body"]];
    cell.textLabel.text = cellValue;
    
    return cell;
}


@end
