AZTableView
===================

Highly customizable UITableView

Example:

```objc

    AZRow *row1 = [AZRow new];
    row1.text = @"Clickable Row";
    row1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    row1.onSelect = ^(AZRow *row, UIView *fromView){
        NSLog(@"onSelect");
    };
    
    AZRow *row2 = [AZRow new];
    row2.text = @"Title";
    row2.detail = @"Detail message";
    row2.image = @"github"; //image named.
    row2.style = UITableViewCellStyleSubtitle;
    
    AZSection *section = [AZSection new];
    [section addRow:row1];
    [section addRow:row2];
    
    AZRoot *root = [AZRoot new];
    [root addSection:section];
    root.grouped = YES;
    
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];

```

Display row extend
---------------------

### AZButtonRow
### AZBadgeRow

Form row extend
---------------------

### AZInputRow
### AZPickerRow
### AZDateRow
### AZSwitchRow
### AZSliderRow
### AZSegmentedRow




