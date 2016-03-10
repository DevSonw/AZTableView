//
//  AZRow.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AZRow.h"
#import "AZTableView.h"
#import "AZConvert.h"

@interface AZRow()

@property(nonatomic, retain) id realAccessoryView;

@end

@implementation AZRow

@synthesize identifier = _identifier, section, text, value, hidden, enabled, focusable, height, ref, data = _data, style = _style, detail, accessoryType, accessoryView = _accessoryView, selected = _selected, deletable, textFont, textFontSize, detailTextFont, detailTextFontSize, detailTextLine, accessibilityLabel, bindData;

@synthesize onSelect, onAccessory, onDelete, onChange, onMove;

@synthesize textColor, detailTextColor, backgroundColor;

@synthesize image, imageURL, selectedImage, imageCornerRadius;

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> text=%@", self.class, self, self.text, nil];
}

+(id)rowWithType:(NSString *)type{
        if ([type isKindOfClass:[NSString class]]) {
            //For extend
            Class cla = NSClassFromString(type);
            if (!cla) {
                if (type && [type length]>0) {
                    type = [type stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[type substringToIndex:1] capitalizedString]];
                }
                cla = NSClassFromString([NSString stringWithFormat:@"AZ%@Row", type]);
            }
            if (cla && [cla isSubclassOfClass:self]) {
                return [cla new];
            } else if(!cla){
                [NSException raise:@"Invalid row type" format:@"type of %@ is invalid", type];
            }
        }
    return [self new];
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (dic[@"bind"]) {
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic];
        [data addEntriesFromDictionary:[AZRoot dataFromBind:dic[@"bind"] source:dic[@"bindData"] ? dic[@"bindData"] : (self.section.bindData ? self.section.bindData : self.section.root.bindData)]];
        return data;
    }
    return dic;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [AZConvert convertForModel:self data:dic root:self.section.root];
    return YES;
}

- (id)init{
    if (self = [super init]) {
        self.enabled = true;
        self.identifier = nil;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.style = UITableViewCellStyleDefault;
        self.detailTextLine = -1;
        self.height = -1;
        self.focusable = NO;
    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    if (self.section.selectable && !self.section.multiple && selected) {
        for (AZRow *row in self.section.rows) {
            if (row != self) {
                row.selected = NO;
            }
        }
    }
    _selected = selected;
}

- (void)setAccessoryView:(id)accessoryView{
    _accessoryView = accessoryView;
    self.realAccessoryView = nil;
}

- (id)realAccessoryView{
    if (!_realAccessoryView && _accessoryView) {
        if ([self.accessoryView isEqual:@"loading"]) {
            UIActivityIndicatorView *activity = [UIActivityIndicatorView new];
            activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [activity startAnimating];
            _realAccessoryView = activity;
        } else {
            //TODO:
//            _realAccessoryView = [AZAccessoryButton buttonWithSetting:self.accessoryView];
        }
    }
    if ([_realAccessoryView isKindOfClass:[UIActivityIndicatorView class]]) {
        [_realAccessoryView startAnimating];
    }
    return _realAccessoryView;
}



- (NSIndexPath *)indexPath{
    if (!self.section) {
        return nil;
    }
    return [NSIndexPath indexPathForRow:[self.section indexForVisibleRow:self] inSection:[self.section.root indexForVisibleSection:self.section]];
}

-(void)willDisplayCell:(AZTableViewCell *)cell forTableView:(AZTableView *)tableView{
}

-(void)didEndDisplayingCell:(AZTableViewCell *)cell forTableView:(AZTableView *)tableView{
    
}


//TODO: move accessoryView to tableViewCell for cache

- (AZTableViewCell *)cellForTableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    AZTableViewCell *cell = [self createCellForTableView:tableView];
    [self updateCell:cell tableView:tableView indexPath:indexPath];
    return cell;
}

- (void)updateCell:(AZTableViewCell *)cell tableView:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = self.text;
    cell.selectionStyle = self.enabled && self.onSelect ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    cell.accessoryType = self.accessoryType;
    cell.detailTextLabel.text = self.detail;
    cell.accessoryView = nil;
    cell.accessibilityLabel = self.accessibilityLabel;
    cell.accessoryView = self.realAccessoryView;
    cell.hideSeparator = self.hideSeparator;
//    if ([self.realAccessoryView respondsToSelector:@selector(clickHandler)]) {
//        __weak AZRow *row = self;
//        ((AZAccessoryButton *)self.realAccessoryView).clickHandler = ^(AZButton *button){
//            [row selectedAccessory:tableView indexPath:indexPath];
//        };
//    }
    
    [self.class setImageForImageView:cell.imageView imageNamed:self.image url:self.imageURL cornerRadius:self.imageCornerRadius];
    
    cell.loading = self.loading;
    cell.textLabel.enabled = self.enabled;
    cell.detailTextLabel.enabled = self.enabled;
    
    //Notice: need set all row color for reuse
    if (self.textColor) {
        [cell setTextColor:self.textColor style:self.style];
        
    }
    if(self.detailTextColor){
        [cell setDetailTextColor:self.detailTextColor style:self.style];
    }
    if(self.backgroundColor){
        cell.backgroundColor = self.backgroundColor;
    }
    
    if (self.textFont) {
        [cell setTextFont:self.textFont size:self.textFontSize style:self.style];
    }
    if (self.detailTextFont) {
        [cell setDetailTextFont:self.detailTextFont size:self.detailTextFontSize style:self.style];
    }
    cell.detailTextLabel.numberOfLines = self.detailTextLine >= 0 ? self.detailTextLine : 1;
    //For selectable
    if (self.section.selectable) {
        cell.selectionStyle = self.enabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
        [self selected:self.selected forCell:cell];
    }
}

- (void)selected:(BOOL)selected forCell:(AZTableViewCell *)cell{
    if (self.selectedImage && self.image) {
        cell.imageView.image = [UIImage imageNamed: selected ? self.selectedImage : self.image];
    } else {
        cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
}

- (AZTableViewCell *)createCellForTableView:(AZTableView *)tableView{
    AZTableViewCell *cell;
    id class = [self cellClass];
    if ([class isKindOfClass:[NSString class]]) {
        NSString *identifier = [NSString stringWithFormat:@"%@%@", class, self.identifier ? [NSString stringWithFormat:@"-%@", self.identifier] : nil];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            [tableView registerNib:[UINib nibWithNibName:self.identifier ? self.identifier : class bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
    } else {
        NSString *identifier = [NSString stringWithFormat:@"%@-%d%@", self.class, (int)self.style, self.identifier ? [NSString stringWithFormat:@"-%@", self.identifier] : nil];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            cell = [[class alloc] initWithStyle:self.style reuseIdentifier:identifier];
        }
    }
    cell.tableView = tableView;
    return cell;
}

- (id)cellClass{
    return [AZTableViewCell class];
}

//TODO: test ios6
- (CGFloat)heightForTableView:(AZTableView *)tableView{
    if (self.height < 0 && self.detailTextLine == 0) {
        float imageWidth = 0.f;
        if (self.image){
            imageWidth = [UIImage imageNamed:self.image].size.width + 15.f;
        }
        float padding = 30.f;
        float fontSize = 12.f;
        CGSize constraint = CGSizeMake(tableView.frame.size.width - imageWidth - padding, 20000);
        UIFont *font = self.detailTextFont ? [UIFont fontWithName:self.detailTextFont size: self.detailTextFontSize > 0 ? self.detailTextFontSize : fontSize] : [UIFont systemFontOfSize:fontSize];
        CGSize  size= [self.detail sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByTruncatingTail];
        //        NSLog(@"font %@, size %@ cons %@", font, NSStringFromCGSize(size), NSStringFromCGSize(constraint));
        CGFloat predictedHeight = size.height + 27.0f;
        if (self.text)
            predictedHeight += 20;
        return predictedHeight;
    }
    return self.height >= 0 ? self.height : 44;
}

- (void)selectedAccessory:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    if (self.onAccessory && self.enabled) {
        self.onAccessory(self, [tableView cellForRowAtIndexPath:indexPath]);
    }
}

- (void)selected:(AZTableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    //Handle selected
    if (self.section.selectable && self.enabled) {
        AZTableViewCell *cell = (AZTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (!self.section.multiple) {
            NSInteger ind = indexPath.section;
            for (NSIndexPath *path in [tableView indexPathsForVisibleRows]) {
                if (path.section == ind && path.row != indexPath.row) {
                    [self selected:NO forCell:(AZTableViewCell *)[tableView cellForRowAtIndexPath:path]];
                }
            }
        }
        self.selected = !self.selected;
        [self selected:self.selected forCell:cell];
        if (self.onChange) {
            self.onChange(self, [tableView cellForRowAtIndexPath:indexPath]);
        }
        [tableView deselect];
    }
    if (self.onSelect && self.enabled) {
        self.onSelect(self, [tableView cellForRowAtIndexPath:indexPath]);
    }
}

+(UIColor *)tintColor{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window respondsToSelector:@selector(tintColor)] && window.tintColor) {
        return window.tintColor;
    }
    if([[UIWindow appearance] respondsToSelector:@selector(tintColor)] && [[UIWindow appearance] tintColor] ){
        return [[UIWindow appearance] tintColor];
    }
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}


+ (void)setImageForImageView:(UIImageView *)imageView imageNamed:(NSString *)imageNamed url:(NSString *)url cornerRadius:(CGFloat)cornerRadius{
    
    UIImage *image = nil;
    CGSize size;
    if (imageNamed) {
        image = [UIImage imageNamed:imageNamed];
        size = image.size;
        if (cornerRadius) {
            image = [image yy_imageByRoundCornerRadius:cornerRadius];
        }
    }
    //Reset the image view.
    //Set the placehoder if has imageURL.
    imageView.image = image;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if ([url length]) {
        __weak UIImageView *_imageView = imageView;
        
        BOOL isBase64 = [url hasPrefix:@"data:image/"];
        if (isBase64) {
            NSArray *ar = [url componentsSeparatedByString:@";base64,"];
            if ([ar count] == 2) {
                NSData *data = [[NSData alloc] initWithBase64EncodedString:ar[1] options:0];
                UIImage *image = [[YYImage alloc] initWithData:data scale:scale];
                if (cornerRadius) {
                    image =[image yy_imageByRoundCornerRadius:cornerRadius];
                }
                //Resize the image.
                if (size.width != image.size.width && size.height != image.size.height) {
                    image = [image yy_imageByResizeToSize:size];
                }
                _imageView.image = image;
            }
            //Parse data async
            //The imageView has display, so size will not changed when image set.
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                });
//            });
        } else {
            [imageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:image options:YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                return image;
            } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                //The animated GIF image in UIImageView will make the cell not smooth when scroll.
//                if ([image isKindOfClass:[YYImage class]]) {
//                    YYImageType type = [(YYImage *)image animatedImageType];
//                    if (type == YYImageTypeGIF) {
//                        //GIF animated.
//                        image = [UIImage yy_imageWithSmallGIFData:[(YYImage *)image animatedImageData] scale:scale];
//                        _imageView.image = image;
//                        return;
//                    }
//                }
                if (cornerRadius) {
                    image =[image yy_imageByRoundCornerRadius:cornerRadius];
                }
                //Resize the image.
                if (size.width != image.size.width && size.height != image.size.height) {
                    image = [image yy_imageByResizeToSize:size];
                }
                _imageView.image = image;
                
            }];
        }
    }
}


@end
