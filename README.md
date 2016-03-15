AZTableView(Development)
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

Requirements
---------------------

iOS 7.0+
Xcode 7.0+


Basic display row 
---------------------

### AZRow

* `text`

### AZButtonRow
### AZBadgeRow

Basic form row
---------------------

All rows extend from AZRow.

### AZInputRow
### AZPickerRow
### AZDateRow
### AZSwitchRow
### AZSliderRow
### AZSegmentedRow


Extend row
---------------------

### AZButtonGroupRow

* `items` Button items, support create by YYModel dictionary
* `separatorColor` Separator color between buttons, default tableView separator color.
* `onSelect` Event when button click. the button index saved at `row.value`

### AZGridSection

The grid view in section.

* `items` The string array for grid.
* `reduceWidth` Reduce the width of the grid. 

### AZGridRow

* `items` The string array for grid.

### AZHtmlRow

* `html` The html string. `<a href="http://..."><font face=red>abc</font><a>`
* `htmlTextLine` The number of text lines
* `onLink` Event when url in html label click.

### AZImagesRow (ImagePage)

Use YYImageView support gif.

* `items` The images data. `[{ image: "", imageURL: "", title: "" }]`
* `slideInterval` The image auto slide interval, default 0.0f don't auto slide.
* `hideIndicator` Don't display the indicator if true.
* `onSlide` Event when slide to the image.
* `onSelect` Event when image click.


### AZCaptchaRow

Use YYImageView support gif.

* `captchaWidth`
* `captchaHeight`
* `captchaURL` support base64 encoding data like imageURL
* `onCaptcha` Event when captcha start refresh









