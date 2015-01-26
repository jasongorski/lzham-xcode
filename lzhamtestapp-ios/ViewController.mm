//
//  ViewController.m
//  lzhamtestapp-ios
//
//  Created by Jason Gorski on 2015-01-26.
//
//

#import "ViewController.h"
#import "lzham_static_lib.h"
#import "lzhamtest_wrap.h"
#include <string>
#include <vector>

typedef std::vector< std::string > string_array;

// created hello.txt.lzma using:
//   lzhamtest-osx -d24 -c -v c assets/hello.txt assets/hello.txt.lzham
//
// md5(<hello.txt) 8ddd8be4b179a529afa5f2ffae4b9858


@interface ViewController ()
@end

@implementation ViewController {
    IBOutlet UITextField *_textField;
}

int main_internal(string_array cmd_line, int num_helper_threads, ilzham &lzham_dll);
- (void)pocDecompressPath:(NSString*)srcPath to:(NSString*)destPath {
    const char *argv[] = {
        "lzhamtest",
        "d",
        [srcPath UTF8String],
        [destPath UTF8String],
        NULL
    };
    int exitCode;

    int argc = 4;
    lzham_static_lib lzham_lib;
    lzham_lib.load();
    
    printf("Loaded LZHAM DLL version 0x%04X\n\n", lzham_lib.lzham_get_version());
    
    string_array cmd_line;
    for (int i = 1; i < argc; i++)
    {
        cmd_line.push_back(std::string(argv[i]));
    }
    
    int num_helper_threads = 1;
    exitCode = main_internal(cmd_line, num_helper_threads, lzham_lib);

    if (exitCode != 0) {
        _textField.text = [NSString stringWithFormat:@"Unexpected result trying to decompress, code {%d}", (unsigned int)exitCode];
    } else {
        NSData *decompressedData = [NSData dataWithContentsOfFile:destPath];
        NSString *decompressedString = [[NSString alloc] initWithData:decompressedData encoding:NSUTF8StringEncoding];
        _textField.text = [NSString stringWithFormat:@"Decompressed: {%@}", decompressedString];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [searchPaths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        if(![[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error]) {
            _textField.text = [NSString stringWithFormat:@"unable to create folder {%@}", cachePath];
            return;
        }
    }
    
    NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"hello.txt.lzham" ofType:@""];
    NSString *destPath = [cachePath stringByAppendingPathComponent:@"hello.txt"];
    [self pocDecompressPath:srcPath to:destPath];
}

@end
