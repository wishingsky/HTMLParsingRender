HTMLParsingRender
=================

HTMLParsingRender is an XML/HTML parser and render for Mac OS X and iOS .
It Dependent on DTCoreText. It parse custom html tag and render by native

![Preview](https://github.com/wishingsky/HTMLParsingRender/blob/master/preview.gif)

Register Class for custom tag

```
[DTTextAttachment registerClass:[TextAttachment class] forTagName:@"ws-text"];
        [DTTextAttachment registerClass:[ImageAttachment class] forTagName:@"ws-image"];
        [DTTextAttachment registerClass:[AudioAttachment class] forTagName:@"ws-audio"];  



```
    _htmlView = [[HtmlView alloc] initWithFrame:self.view.bounds];
    _htmlView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self.view addSubview:_htmlView];
    
    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"Test.html" ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:NULL];
    
    [_htmlView bindHtmlString:html];

   Custom view to render for native
     
        
    _htmlView.customImageView = ^(NSString *imageURL, CGRect frame){

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed: @"default"]];
        
        return imageView;
    };
    
    
    __weak typeof(self) weakSelf = self;
    _htmlView.customAudioView = ^(NSString *audioURL, NSTimeInterval duration, CGRect frame){
        
        WSAudioView *audioView = [[NSBundle mainBundle] loadNibNamed:@"WSAudioView" owner:weakSelf options:nil].firstObject;
        audioView.frame = frame;
        audioView.audioUrl = audioURL;
        
        return audioView;
    };
    
    _htmlView.customTextView = ^(NSAttributedString *attributedString, CGRect frame){
        
        WSTextView *textView = [[WSTextView alloc] initWithFrame:frame];
        textView.attributedString = attributedString;
        
        return textView;
    };

License:
=================
The MIT License. See the LICENSE file for more infomation.
