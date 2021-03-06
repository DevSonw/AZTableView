//
//  AppDelegate.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AppDelegate.h"

#import "AZTableView.h"
#import "AZInputRow.h"
#import "AZPickerRow.h"
#import "AZBadgeRow.h"
#import "AZGridRow.h"
#import "AZGridSection.h"
#import "AZHtmlRow.h"

//#import <objc/runtime.h>
//static void *TITLEKEY;
//
//@interface AZRoot (WithTitle)
//@property (strong, nonatomic) NSString *title;
//@end
//
//@implementation AZRoot(WithTitle)
//@dynamic title;
//
//-(void)setTitle:(NSString *)title{
//    objc_setAssociatedObject(self, TITLEKEY, title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSString *)title{
//    return objc_getAssociatedObject(self, TITLEKEY);
//}
//
//@end

static NSString *NSStringFromIndexPath(NSIndexPath *indexPath){
    return [NSString stringWithFormat:@"section %d, row %d", (int)indexPath.section, (int)indexPath.row];
}


@interface AppDelegate ()

@end

@implementation AppDelegate

- (AZRow *)createRow:(UIViewController *)cont rootViewController:(UIViewController *)root{
    AZRow *row = [AZRow new];
    row.text = cont.title;
    row.onSelect = ^(AZRow *row, UIView *fromView){
        [root.navigationController pushViewController:cont animated:YES];
    };
    return row;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc] init];
    self.window = window;
    window.tintColor = [UIColor redColor]; // Change tint color
    
    UIViewController *viewController = [UIViewController new];
    AZSection *section = [AZSection new];
    NSDate *date = [NSDate date];
    NSArray *ar = [NSArray arrayWithObjects:
                   [self displayRow],
                   [self formRow],
                   [self rowEvent],
                   [self advancedFormRow],
                   [self accessoryViewRow],
                   [self buttonGroupRow],
                   [self gridRow],
                   [self htmlRow],
                   nil];
    NSLog(@"Create time: %f s", [[NSDate date] timeIntervalSinceDate:date]);
    //    NSArray *ar = [NSArray arrayWithObjects:[self jsonCont], nil];
    
    for (UIViewController *cont in ar) {
        [section addRow:[self createRow:cont rootViewController:viewController]];
    }
    
    AZRoot *root = [AZRoot new];
    [root addSection:section];
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    viewController.view = tableView;
    viewController.title = @"AZTableView Example";
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.window makeKeyAndVisible];
    return YES;
}


-(UIViewController *)displayRow{
    AZRow *row1 = [AZRow new];
    row1.text = @"Default row";
    
    AZRow *row2 = [AZRow new];
    row2.text = @"Style subtitle";
    row2.detail = @"The detail";
    row2.cellStyle = UITableViewCellStyleSubtitle;
    
    AZRow *row3 = [AZRow new];
    row3.text = @"Style value1";
    row3.detail = @"Value";
    row3.cellStyle = UITableViewCellStyleValue1;
    
    AZRow *row4 = [AZRow new];
    row4.text = @"Style value2";
    row4.detail = @"Value";
    row4.cellStyle = UITableViewCellStyleValue2;
    
    AZRow *row5 = [AZRow new];
    row5.text = @"Row with image name";
    row5.detail = @"Set the image corner radius 10";
    row5.cellStyle = UITableViewCellStyleSubtitle;
    row5.imageCornerRadius = 10.f;
    row5.image = @"github";
    
    AZRow *row6 = [AZRow new];
    row6.text = @"Row with image url";
    row6.detail = @"The image from url will be resized to the named image";
    row6.cellStyle = UITableViewCellStyleSubtitle;
    row6.imageCornerRadius = 10.f;
    row6.image = @"github"; //Placehoder for image
    row6.imageURL = @"https://github.com/fluidicon.png?v=2";

    AZRow *row7 = [AZRow new];
    row7.text = @"Base64 style image url";
    row7.detail = @"Base64 encoding image data";
    row7.cellStyle = UITableViewCellStyleSubtitle;
    row7.imageCornerRadius = 10.f;
    row7.image = @"github"; //Placehoder for image
    row7.imageURL = @"data:image/png;base64,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";

    AZRow *row8 = [AZRow new];
    row8.text = @"Gif image from url";
    row8.detail = @"Can't animate in UIImageView";
    row8.cellStyle = UITableViewCellStyleSubtitle;
    row8.image = @"github"; //Placehoder for image
    row8.imageURL = @"http://f.hiphotos.baidu.com/zhidao/pic/item/1e30e924b899a901f13830bc1f950a7b0208f52f.jpg?v=4";

    AZRow *row9 = [AZRow new];
    row9.text = @"Webp image from url";
    row9.detail = @"Can't animate in UIImageView";
    row9.cellStyle = UITableViewCellStyleSubtitle;
    row9.image = @"github"; //Placehoder for image
    row9.imageURL = @"http://littlesvr.ca/apng/images/GenevaDrive.webp?v=1";
    
    AZRow *row10 = [AZRow new];
    row10.text = @"Change row height";
    row10.height = 80.f;
    
    AZRow *row11 = [AZRow new];
    row11.text = @"Detail number of lines 2";
    row11.cellStyle = UITableViewCellStyleSubtitle;
    row11.detail = @"AlphaGo's algorithm uses a combination of machine learning and tree search techniques, combined with extensive training, both from human and computer play.";
    row11.detailTextLine = 3;
    row11.height = 80.f;
    
    AZRow *row12 = [AZRow new];
    row12.cellStyle = UITableViewCellStyleSubtitle;
    row12.detail = @"Unlimit line: AlphaGo's algorithm uses a combination of machine learning and tree search techniques, combined with extensive training, both from human and computer play.";
    row12.detailTextLine = 0;
    
    AZRow *hideSeparator = [AZRow new];
    hideSeparator.text = @"Hide separator line";
    hideSeparator.hideSeparator = YES;


    AZSection *section = [AZSection new];
    [section addRow:row1];
    [section addRow:row2];
    [section addRow:row3];
    [section addRow:row4];
    [section addRow:row5];
    [section addRow:row6];
    [section addRow:row7];
    [section addRow:row8];
    [section addRow:row9];
    [section addRow:row10];
    [section addRow:hideSeparator];
    [section addRow:row11];
    [section addRow:row12];
    
    
    AZSection *section1 = [AZSection new];
    section1.header = @"Badge";
    
    AZBadgeRow *row13 = [AZBadgeRow new];
    row13.text = @"With Select Event";
    row13.badge = @"1";
    row13.badgeColor = [UIColor redColor];
    row13.onSelect =  ^(AZRow *row, UIView *fromView){
        NSLog(@"onSelect");
        [self alert:@"onSelect" message:nil];
    };

    
    AZBadgeRow *row14 = [AZBadgeRow new];
    row14.text = @"Without Badge";
    row14.textColor = [UIColor redColor];
    
    AZBadgeRow *row15 = [AZBadgeRow new];
    row15.badge = @"2";
    row15.text = @"Default Badge row";
    
    AZBadgeRow *row16 = [AZBadgeRow new];
    row16.text = @"Custom Badge Text Color";
    row16.badge = @"A";
    row16.badgeTextColor = [UIColor redColor];
    row16.badgeColor = [UIColor blackColor];
    
    [section1 addRow:row13];
    [section1 addRow:row14];
    [section1 addRow:row15];
    [section1 addRow:row16];
    

    AZRoot *root = [AZRoot new];
    [root addSection:section];
    [root addSection:section1];
    
    root.grouped = YES;
    
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    
    UIViewController *cont = [UIViewController new];
    cont.title = @"Basic display row";
    cont.view = tableView;
    return cont;
}

- (void)alert:(NSString *)title message:(NSString *)message{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)alert:(NSString *)title message:(NSString *)message fromViewController:(UIViewController *)viewController{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [viewController presentViewController:controller animated:YES completion:nil];
}

-(UIViewController *)formRow{
    UIViewController *cont = [UIViewController new];
    
    AZInputRow *row1 = [AZInputRow new];
    row1.text = @"Name";
    row1.placeholder = @"placeholderTextColor:cyan";
    row1.placeholderTextColor = [UIColor cyanColor];
    
    AZInputRow *row2 = [AZInputRow new];
    row2.text = @"Password";
    row2.placeholder = @"secureTextEntry";
    row2.secureTextEntry = YES;
    
    AZInputRow *row3 = [AZInputRow new];
    row3.text = @"Name";
    row3.value = @"Default value";
    
    AZInputRow *row4 = [AZInputRow new];
    row4.text = @"Name";
    row4.value = @"Disabled";
    row4.enabled = false;
  
    AZInputRow *row5 = [AZInputRow new];
    row5.text = @"Name";
    row5.cellStyle = UITableViewCellStyleSubtitle;
    row5.detailTextColor = [UIColor redColor];
    row5.placeholder = @"Placeholder";
    row5.detail = @"Help text";
    row5.height = 60.f;
    
    AZInputRow *row6 = [AZInputRow new];
    row6.text = @"Style:value2";
    row6.cellStyle = UITableViewCellStyleValue2;
    row6.value = @"Default value";
    
    AZInputRow *row7 = [AZInputRow new];
    row7.text = @"Name";
    row7.placeholder = @"hiddenToolbar";
    row7.hiddenToolbar = YES;
  
    AZInputRow *row8 = [AZInputRow new];
    row8.text = @"Name";
    row8.placeholder = @"hiddenPrevAndNext";
    row8.hiddenPrevAndNext = YES;
  
    AZInputRow *row9 = [AZInputRow new];
    row9.text = @"Name";
    row9.placeholder = @"autoCorrect";
    row9.autoCorrect = NO;

    AZInputRow *row10 = [AZInputRow new];
    row10.text = @"Name";
    row10.placeholder = @"autoCapitalize:none";
    row10.autoCapitalize = UITextAutocapitalizationTypeNone;

    AZInputRow *row11 = [AZInputRow new];
    row11.text = @"Number";
    row11.placeholder = @"keyboardType:number-pad";
    row11.keyboardType = UIKeyboardTypeNumberPad;

    AZInputRow *row12 = [AZInputRow new];
    row12.text = @"Name";
    row12.placeholder = @"keyboardAppearance:dark";
    row12.keyboardAppearance = UIKeyboardAppearanceDark;
    
    AZInputRow *row13 = [AZInputRow new];
    row13.text = @"Name";
    row13.placeholder = @"clearsOnBeginEditing";
    row13.clearsOnBeginEditing = YES;
    
    AZRoot *root = [AZRoot new];
    AZSection *section = [AZSection new];
    section.header = @"Input";
    [section addRow:row1];
    [section addRow:row2];
    [section addRow:row3];
    [section addRow:row4];
    [section addRow:row5];
    [section addRow:row6];
    [section addRow:row7];
    [section addRow:row8];
    [section addRow:row9];
    [section addRow:row10];
    [section addRow:row11];
    [section addRow:row12];
    [section addRow:row13];
    
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];

    AZSection *section1 = [AZSection new];
    section1.header = @"Picker";
    
    
    AZPickerRow *row14 = [AZPickerRow new];
    row14.text = @" Picker";
    row14.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    row14.items = @[@[@"A",@"B",@"C",@"E",@"F"]];
    row14.value = @"A";
    
    AZPickerRow *row15 = [AZPickerRow new];
    row15.text = @"Two Picker";
    row15.placeholder = @"placeholder";
    row15.cellStyle = UITableViewCellStyleSubtitle;
    row15.detailTextColor = [UIColor blueColor];
    
    NSArray *items1 = @[@[@"A",@"B",@"C"],@[@"A",@"B",@"C"]];
    NSArray *items2 = @[@[@"A",@"B",@"C"],@[@"A",@"B",@"C", @"D", @"E", @"F"]];

    row15.items = items1;
    row15.value = @[@"A",@"B"];
    
    __weak AZPickerRow *weakRow15 = row15;
    __block BOOL switched = NO;
    row15.onChange = ^(AZRow *row, UIView *fromView){
        NSLog(@"onChange %@", row.value);
        weakRow15.items = switched ? items1 : items2;
        switched = !switched;
        weakRow15.value = @[row.value[0], @"A"];
        [tableView updateCellForRow:row indexPath:row.visibleIndexPath];
    };
    row15.onBlur = ^(AZRow *row, UIView *fromView){
        NSLog(@"onBlur %@", row.value);
    };
    
    AZPickerRow *row16 = [AZPickerRow new];
    row16.text = @"Three Picker";
    row16.items =@[@[@"A",@"B",@"C"],@[@"A",@"B",@"C"],@[@"D",@"E",@"F"]];
    row16.value = @[@"A",@"B",@"E"];
    
    AZPickerRow *row17 = [AZPickerRow new];
    row17.text = @"Without default Selected";
    row17.items = @[@[@"A",@"B",@"C"],@[@"A",@"B",@"C"]];
    
    [section1 addRow:row14];
    [section1 addRow:row15];
    [section1 addRow:row16];
    [section1 addRow:row17];
    
    [root addSection:section];
    [root addSection:section1];
    
    tableView.editing = YES; //For deletable, sortable
    cont.title = @"Form row";
    cont.view = tableView;
    return cont;
}


-(UIViewController *)rowEvent{
    UIViewController *cont = [UIViewController new];
    AZRoot *root = [AZRoot new];
    root.grouped = YES;
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    __weak AZTableView *weakTableView = tableView;
    
    AZRow *row1 = [AZRow new];
    row1.text = @"onSelect";
    row1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    row1.onSelect = ^(AZRow *row, UIView *fromView){
        NSLog(@"onSelect");
        [self alert:@"onSelect" message:nil];
    };
    
    AZRow *row2 = [AZRow new];
    row2.text = @"onAccessory";
    row2.accessoryType = UITableViewCellAccessoryDetailButton;
    row2.onAccessory = ^(AZRow *row, UIView *fromView){
        NSLog(@"onSelect");
        [self alert:@"onAccessory" message:nil];
    };

    AZInputRow *row3 = [AZInputRow new];
    row3.text = @"Input";
    row3.placeholder = @"onFocus,onBlur";
    row3.onFocus = ^(AZRow *row, UIView *fromView){
        NSLog(@"onFocus");
        cont.title = [NSString stringWithFormat:@"Input onFocus: %@", row.value];
    };
    row3.onBlur = ^(AZRow *row, UIView *fromView){
        NSLog(@"onBlur");
        cont.title = [NSString stringWithFormat:@"Input onBlur: %@", row.value];
    };
    
    AZInputRow *row4 = [AZInputRow new];
    row4.text = @"Input";
    row4.placeholder = @"onChange,onDone";
    row4.onChange = ^(AZRow *row, UIView *fromView){
        NSLog(@"onChange: %@", row.value);
        cont.title = [NSString stringWithFormat:@"Input onChange: %@", row.value];
    };
    row4.onDone = ^(AZRow *row, UIView *fromView){
        NSLog(@"onDone");
        cont.title = [NSString stringWithFormat:@"Input onDone: %@", row.value];
    };

    AZRow *row5 = [AZRow new];
    row5.text = @"onDelete";
    row5.deletable = YES;
    
    row5.onDelete = ^(AZRow *row, UIView *fromView){
        NSLog(@"onDelete");
        [weakTableView deleteRow:row indexPath:[row visibleIndexPath]];
        [self alert:@"onDelete" message:nil];
    };

    AZSection *section = [AZSection new];
    [section addRow:row1];
    [section addRow:row2];
    [section addRow:row3];
    [section addRow:row4];
    [section addRow:row5];
    

    [root addSection:section];

    tableView.editing = YES; //For deletable
    cont.title = @"Row event";
    cont.view = tableView;
    return cont;
}


-(UIViewController *)advancedFormRow{
    
    AZRoot *root = [AZRoot new];
    root.grouped = YES;
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    tableView.editing = YES;
    
    UIViewController *cont = [UIViewController new];
    
    AZSection *sortSection1 = [AZSection new];
    sortSection1.header = @"Group0";
    AZSection *sortSection2 = [AZSection new];
    sortSection2.header = @"Group1";

    for (int i = 0; i < 3; i++) {
        AZRow *row = [AZRow new];
        row.sortable = YES;
        row.data = @[@(0), @(i)];
        row.text = [NSString stringWithFormat:@"Group 0, Item %d", i];
        row.onMove = ^(AZRow *row, UIView *fromView){
            NSLog(@"onMove %@", NSStringFromIndexPath(row.visibleIndexPath));
            NSLog(@"%@, %@", sortSection1.rows, sortSection2.rows);
            cont.title = [NSString stringWithFormat:@"onMove: %@", NSStringFromIndexPath(row.visibleIndexPath)];
        };
        [sortSection1 addRow:row];
    }
    
    for (int i = 0; i < 3; i++) {
        AZRow *row = [AZRow new];
        row.sortable = YES;
        row.data = @[@(1), @(i)];
        row.text = [NSString stringWithFormat:@"Group 1, Item %d", i];
        row.onMove = ^(AZRow *row, UIView *fromView){
            NSLog(@"onMove %@", NSStringFromIndexPath(row.visibleIndexPath));
            NSLog(@"%@, %@", sortSection1.rows, sortSection2.rows);
            cont.title = [NSString stringWithFormat:@"onMove: %@", NSStringFromIndexPath(row.visibleIndexPath)];
        };
        [sortSection2 addRow:row];
    }
    
    AZSection *singleSelectSection = [AZSection new];
    singleSelectSection.header = @"Single";
    
    __block AZRow *selectedRow = nil;
    for (int i = 0; i < 3; i++) {
        AZRow *row = [AZRow new];
        if (i == 0) {
            row.accessoryType = UITableViewCellAccessoryCheckmark;
            selectedRow = row;
        }
        
        row.text = [NSString stringWithFormat:@"Item %d", i];
        row.onSelect = ^(AZRow *row, UIView *fromView){
            selectedRow.accessoryType = UITableViewCellAccessoryNone;
            row.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [tableView updateCellForRow:selectedRow indexPath:selectedRow.visibleIndexPath];
            [tableView updateCellForRow:row indexPath:row.visibleIndexPath];
            [tableView deselect];
            selectedRow = row;
        };
        [singleSelectSection addRow:row];
    }

    
    AZSection *multipleSelectSection = [AZSection new];
    multipleSelectSection.header = @"Multiple";
    
    for (int i = 0; i < 3; i++) {
        AZRow *row = [AZRow new];
        
        row.text = [NSString stringWithFormat:@"Item %d", i];
        row.onSelect = ^(AZRow *row, UIView *fromView){
            row.value =  [row.value isEqual:@(1)] ? @(0) : @(1);
            row.accessoryType = [row.value isEqual:@(1)] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            [tableView updateCellForRow:row indexPath:row.visibleIndexPath];
            [tableView deselect];
        };
        [multipleSelectSection addRow:row];
    }

    
    [root addSection:sortSection1];
    [root addSection:sortSection2];
    [root addSection:singleSelectSection];
    [root addSection:multipleSelectSection];

    cont.title = @"Advanced from: sortable, selectable";
    cont.view = tableView;
    return cont;
}

-(UIViewController *)dictionaryCont{
    
    AZRowEvent event = ^(AZRow *row, UIView *from){
        NSLog(@"onSelect from json");
    };
    
    NSDictionary *dict = @{
                           @"grouped": @(YES),
                           @"sections": @[
                                   @{
                                       @"header": @"Header",
                                       @"rows": @[
                                               @{
                                                   @"text": @"Title",
                                                   @"onSelect": event,
                                                   @"type": @"button",
                                                   },
                                               @{
                                                   @"text": @"Title",
                                                   @"detail": @"Detail",
                                                   @"cellStyle": @"subtitle",
                                                   @"onSelect": @"row2Select",
                                                   }
                                               ]
                                       }
                                   ]
                           };
    
    AZRoot *root = [AZRoot new];
    root.onEvent = ^(NSString *eventName, AZRow *row, UIView *from){
        NSLog(@"on %@", eventName);
    };
    [root yy_modelSetWithJSON:dict];

    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    UIViewController *cont = [UIViewController new];
    cont.title = @"From Dictionary";
    cont.view = tableView;
    return cont;
}

-(UIViewController *)jsonController:(NSString *)name{

    NSString *json = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *dic = json ? [NSJSONSerialization JSONObjectWithData:[(NSString *)json dataUsingEncoding : NSUTF8StringEncoding] options:kNilOptions error:NULL] : nil;
    
    AZRoot *root = [AZRoot new];
    [root yy_modelSetWithJSON:dic];
    
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];

    UIViewController *cont = [UIViewController new];
    cont.title = dic[@"title"];
    cont.view = tableView;
    return cont;
}

-(UIViewController *)accessoryViewRow{
    
    UIViewController *cont = [UIViewController new];
    __weak UIViewController *weakCont = cont;
    AZRow *row1 = [AZRow new];
    row1.text = @"Checkmark";
    row1.accessoryType = UITableViewCellAccessoryCheckmark;
    
    AZRow *row2 = [AZRow new];
    row2.text = @"Detail button";
    row2.accessoryType = UITableViewCellAccessoryDetailButton;
    
    row2.onAccessory = ^(AZRow *row, UIView *fromView){
        [self alert:@"onAccessory" message:nil fromViewController:weakCont];
    };
    
    AZRow *row3 = [AZRow new];
    row3.text = @"Detail disclosure button";
    row3.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    AZRow *row4 = [AZRow new];
    row4.text = @"Disclosure indicator";
    row4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    AZRow *row5 = [AZRow new];
    row5.text = @"Custom loading accessory";
    row5.accessoryView = [AZLoadingAccessoryView new];
    row5.onAccessory = ^(AZRow *row, UIView *fromView){
        [self alert:@"onAccessory" message:nil fromViewController:weakCont];
    };
    
    AZRow *row6 = [AZRow new];
    row6.text = @"Custom button accessory";
    AZAccessoryView *btn = [AZAccessoryView new];
    btn.title = @"View";
    row6.accessoryView = btn;
    row6.onAccessory = ^(AZRow *row, UIView *fromView){
        [self alert:@"onAccessory" message:nil fromViewController:weakCont];
    };
    
    AZRow *row7 = [AZRow new];
    row7.text = @"Custom button with image";
    AZAccessoryView *btn1 = [AZAccessoryView new];
    btn1.title = @"Github";
    btn1.image = [UIImage imageNamed:@"github-icon"];
    btn1.borderColor = [UIColor redColor];
    row7.accessoryView = btn1;
    row7.onAccessory = ^(AZRow *row, UIView *fromView){
        [self alert:@"onAccessory" message:nil fromViewController:weakCont];
    };

    AZRow *row8 = [AZRow new];
    row8.text = @"disabled button";
    AZAccessoryView *btn2 = [AZAccessoryView new];
    btn2.title = @"View";
    btn2.enabled = NO;
    row8.accessoryView = btn2;
    row8.onAccessory = ^(AZRow *row, UIView *fromView){
        [self alert:@"onAccessory" message:nil fromViewController:weakCont];
    };
    
    AZRow *row9 = [AZRow new];
    row9.text = @"without border";
    AZAccessoryView *btn3 = [AZAccessoryView new];
    btn3.title = @"View";
    btn3.borderWidth = 0.f;
    row9.accessoryView = btn3;
    row9.onAccessory = ^(AZRow *row, UIView *fromView){
        [self alert:@"onAccessory" message:nil fromViewController:weakCont];
    };
    
    AZRow *row10 = [AZRow new];
    row10.text = @"Custom backgroundColor";
    AZAccessoryView *btn4 = [AZAccessoryView new];
    btn4.title = @"View";
    btn4.titleColor = [UIColor whiteColor];
    btn4.backgroundColor = [AZRow  tintColor];
    row10.accessoryView = btn4;
    row10.onAccessory = ^(AZRow *row, UIView *fromView){
        [self alert:@"onAccessory" message:nil fromViewController:weakCont];
    };
    
    AZRow *row11 = [AZRow new];
    row11.text = @"Custom from dictionary";
    row11.accessoryView = @{
                            @"title": @"View",
                            @"titleColor": @"white",
                            @"backgroundColor": @"blue",
                            @"borderWidth": @(0),
                            };
    row11.onAccessory = ^(AZRow *row, UIView *fromView){
        [self alert:@"onAccessory" message:nil fromViewController:weakCont];
    };
    
    AZRow *row12 = [AZRow new];
    row12.text = @"disabled from dictionary";
    row12.accessoryView = @{
                            @"title": @"View",
                            @"titleColor": @"white",
                            @"backgroundColor": @"gray",
                            @"borderWidth": @(0),
                            @"enabled": @(0),
                            };
    row12.onAccessory = ^(AZRow *row, UIView *fromView){
        [self alert:@"onAccessory" message:nil fromViewController:weakCont];
    };

    AZSection *section = [AZSection new];
    [section addRow:row1];
    [section addRow:row2];
    [section addRow:row3];
    [section addRow:row4];
    [section addRow:row5];
    [section addRow:row6];
    [section addRow:row7];
    [section addRow:row8];
    [section addRow:row9];
    [section addRow:row10];
    [section addRow:row11];
    [section addRow:row12];

    AZRoot *root = [AZRoot new];
    [root addSection:section];
    root.grouped = YES;
    
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    tableView.editing = YES; //For deletable
    cont.title = @"Accessory view in row";
    cont.view = tableView;
    return cont;
}

-(UIViewController *)exampleRow{
    UIViewController *cont = [UIViewController new];
    
    AZRow *row1 = [AZInputRow new];
    row1.text = @"Name";
    
    AZRoot *root = [AZRoot new];
    AZSection *section = [AZSection new];
    [root addSection:section];
    section.header = @"Input";
    [section addRow:row1];
    
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    cont.title = @"Example";
    cont.view = tableView;
    return cont;
}

-(UIViewController *)buttonGroupRow{
    UIViewController *cont = [UIViewController new];
    __weak UIViewController *weakCont = cont;
    AZButtonGroupRow *row1 = [AZButtonGroupRow new];
    AZButton *btn1 = [AZButton new];
    btn1.title = @"btn1";
    AZButton *btn2 = [AZButton new];
    btn2.title = @"btn2";
    AZButton *btn3 = [AZButton new];
    btn3.title = @"btn3";
    row1.items = @[btn1, btn2, btn3];
    row1.height = 60.f;
    row1.onSelect =   ^(AZRow *row, UIView *fromView){
        NSLog(@"onSelect");
        [self alert:@"onSelect" message:[NSString stringWithFormat:@"select index: %@", row.value] fromViewController:weakCont];
    };
    
    AZButtonGroupRow *row2 = [AZButtonGroupRow new];
    row2.height = 60.f;
    row2.items = @[
  @{ @"title": @"btn1", @"image": @"github-icon"},
  @{ @"title": @"btn2", @"image": @"github-icon"},
  @{ @"title": @"disabled", @"image": @"github-icon", @"enabled": @(0)},
  ];
    row2.separatorColor = [UIColor clearColor];
    row2.onSelect =   ^(AZRow *row, UIView *fromView){
        NSLog(@"onSelect");
        [self alert:@"onSelect" message:[NSString stringWithFormat:@"select index: %@", row.value] fromViewController:weakCont];
    };
    
    AZButtonGroupRow *row3 = [AZButtonGroupRow new];
    row3.height = 80.f;
    row3.items = @[
                   @{ @"title": @"btn1", @"image": @"github-icon", @"verticalSpacing": @(4)},
                   @{ @"title": @"btn2", @"image": @"github-icon", @"verticalSpacing": @(4)},
                   @{ @"title": @"disabled", @"image": @"github-icon", @"verticalSpacing": @(4), @"enabled": @(0)},
                   ];
    row3.onSelect =   ^(AZRow *row, UIView *fromView){
        NSLog(@"onSelect");
        [self alert:@"onSelect" message:[NSString stringWithFormat:@"select index: %@", row.value] fromViewController:weakCont];
    };
    
    AZRoot *root = [AZRoot new];
    AZSection *section = [AZSection new];
    [root addSection:section];
    [section addRow:row1];
    [section addRow:row2];
    [section addRow:row3];

    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    cont.title = @"Button group row";
    cont.view = tableView;
    return cont;
}

- (UIViewController *)gridRow
{
    UIViewController *cont = [UIViewController new];
    
    AZRoot *root = [AZRoot new];
    
    AZGridSection *section = [AZGridSection new];
    section.items = @[@"h1",@"h2",@"h3"];
    [root addSection:section];
    
    AZGridRow *row = [AZGridRow new];
    row.items =  @[@"A",@"B",@"C"];
    row.text = @"A";
    [section addRow:row];
    
    AZGridRow *row1 = [AZGridRow new];
    row1.items =  @[@"AA",@"BB",@"CC"];
    row1.text = @"AA";
    [section addRow:row1];

    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    tableView.editing = YES; //For deletable, sortable
    cont.title = @"Gird row";
    cont.view = tableView;
    return cont;
}

- (UIViewController *)htmlRow
{
    UIViewController *cont = [UIViewController new];
    
    AZRoot *root = [AZRoot new];
    
    AZSection *section = [AZSection new];
    section.header = @"HTML";
    [root addSection:section];
    
    AZHtmlRow *row1 = [AZHtmlRow new];
    row1.html = @"<font color=blue>blue</font> <i>only html label</i><b color=blue>blue</b> ";
    [section addRow:row1];
    
    AZHtmlRow *row2 = [AZHtmlRow new];
    row2.text = @"HTML text with title";
    row2.html = @"<font color=blue>blue</font> <b>bold</b> and <i>italic</i> style";
    [section addRow:row2];
    
    AZHtmlRow *row3 = [AZHtmlRow new];
    row3.text = @"With title and detail";
    row3.detail = @"detail text";
    row3.html = @"<font color=blue>blue</font> <b>bold</b> and <i>italic</i> style long long long long long long long long long long";
    [section addRow:row3];
    
    AZHtmlRow *row4 = [AZHtmlRow new];
    row4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    row4.image = @"github@2x";
    row4.detail = @"detail";
    row4.text = @"Auto resize height";
    row4.html = @"<b color=blue>blue</b> <b>bold</b> and <i>italic</i> style, <font face='HelveticaNeue-CondensedBold' color='#CCFF00'>Text with</font> <font face='AmericanTypewriter' color=purple>different colours</font> <font face='Futura' size=17 color='#dd1100'>and sizes</font><p><a href='http://google.com'>Clickable</a></p>";
    row4.htmlTextLine = 0;
    row4.onLink = ^(AZRow *row, UIView *fromView){
        [self alert:row.value message:@""];
    };
    row4.onSelect = ^(AZRow *row, UIView *fromView){
        [self alert:row.text message:@""];
    };
    [section addRow:row4];
    
    AZHtmlRow *row5 = [AZHtmlRow new];
    row5.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    row5.image = @"github@2x";
    row5.detail = @"detail long long \n long";
    row5.text = @"Auto resize height";
    row5.detailTextLine = 0;
    row5.html = @"<b color=blue>blue</b> <b>bold</b> and <i>italic</i> style, <font face='HelveticaNeue-CondensedBold' color='#CCFF00'>Text with</font> <font face='AmericanTypewriter' color=purple>different colours</font> <font face='Futura' size=17 color='#dd1100'>and sizes</font><p><a href='http://google.com'>Clickable</a></p>";
    row5.htmlTextLine = 0;
    row5.onLink = ^(AZRow *row, UIView *fromView){
        [self alert:row.value message:@""];
    };
    row5.onSelect = ^(AZRow *row, UIView *fromView){
        [self alert:row.text message:@""];
    };
    [section addRow:row5];
    
    AZHtmlRow *row6 = [AZHtmlRow new];
    row6.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    row6.image = @"github@2x";
    row6.html = @"<b color=blue>blue</b> <b>bold</b> and <i>italic</i> style, <font face='HelveticaNeue-CondensedBold' color='#CCFF00'>Text with</font> <font face='AmericanTypewriter' color=purple>different colours</font> <font face='Futura' size=17 color='#dd1100'>and sizes</font><p><a href='http://google.com'>Clickable</a></p>";
    row6.htmlTextLine = 0;
    row6.onLink = ^(AZRow *row, UIView *fromView){
        [self alert:row.value message:@""];
    };
    row6.onSelect = ^(AZRow *row, UIView *fromView){
        [self alert:row.text message:@""];
    };
    [section addRow:row6];
    
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    tableView.editing = YES; //For deletable, sortable
    cont.title = @"Html row";
    cont.view = tableView;
    
    return cont;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
