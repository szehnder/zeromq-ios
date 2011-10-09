//
//  ZeroMQ_Monitor_IOSViewController.h
//  ZeroMQ Monitor IOS
//
//  Created by Sean Zehnder on 10/8/11.
//  Copyright 2011 seanzehnder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatTableDelegate;

@interface ZeroMQ_Monitor_IOSViewController : UIViewController<UITableViewDataSource> {
    NSMutableArray *messages;
    UITableView *mainTableView;
//    UITextField *messageInputField;
}

//@property (strong, nonatomic) IBOutlet UITextField *messageInputField;
@property(strong, nonatomic) IBOutlet NSMutableArray *messages;
@property(strong, nonatomic) IBOutlet UITableView *mainTableView;


-(IBAction) sendMessageClicked:(id)sender;
-(IBAction) showSettingsClicked:(id)sender;
-(IBAction) hideSettingsClicked:(id)sender;


@end
