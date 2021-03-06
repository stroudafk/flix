//
//  DetailsViewController.m
//  flix
//
//  Created by Sj Stroud on 6/23/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;



@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.posterView.layer.cornerRadius = 20.0;
   
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];

    
    //check if valid URL
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    //check if valid URL
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    
    NSString *reformattedDate = self.movie[@"release_date"];
    reformattedDate = [reformattedDate substringFromIndex:5];
    NSString *months = [reformattedDate substringToIndex:1];
    NSInteger monthsInt = [months integerValue];
    if( monthsInt < 10){
        reformattedDate = [reformattedDate substringFromIndex:1];
    }


    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.categoryLabel.text = reformattedDate;


    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[(id) [UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    
    gradient.frame = self.backdropView.bounds;
    
    [self.backdropView.layer insertSublayer:gradient atIndex:0];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
