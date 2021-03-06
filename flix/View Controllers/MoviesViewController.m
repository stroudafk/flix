//
//  MoviesViewController.m
//  flix
//
//  Created by Sj Stroud on 6/23/21.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"


@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;




@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Do any additional setup after loading the view.

    
    [self fetchMovies];

    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    //^prevents the loading circle from briefly obscuring the first cell
    //but [self.tableView addSubview:self.refreshControl]; will also work

}


- (void)fetchMovies {

    [self.loadIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zoinks, Scoob!" message:@"Check your network connection and try again." preferredStyle:(UIAlertControllerStyleAlert)];
            
               
               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                   //add okay action to the alert controller
               }];
               
               [alert addAction:okAction];
               [self presentViewController:alert animated:YES completion:^{
                   
               }];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);
               
               self.movies = dataDictionary[@"results"];
               
               [self.tableView reloadData];

           }
            [self.refreshControl endRefreshing];
       }];
    [task resume];
    
    [self.loadIndicator stopAnimating];
}

- (void)didRecieveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any recourse that can be recreated.
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    //check if valid URL
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    cell.posterView.layer.cornerRadius = 10.0;
    //clear out previous image before loading in new one (bc of lazy loading)
    [cell.posterView setImageWithURL:posterURL];
        
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


@end

