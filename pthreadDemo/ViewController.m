//
//  ViewController.m
//  pthreadDemo
//
//  Created by pp on 2018/7/2.
//  Copyright © 2018年 webank. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


/*
  主线程 + 异步执行 + 并行队列

  1. ---start---, thread: <NSThread: 0x60000007d040>{number = 1, name = main}
  2. ---end---, thread: <NSThread: 0x60000007d040>{number = 1, name = main}
  3. 任务3---thread:<NSThread: 0x60400046e300>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue>
  4. 任务1---thread:<NSThread: 0x60000027ad40>{number = 4, name = (null)}---queue:<OS_dispatch_queue: my queue>
  5. 任务2---thread:<NSThread: 0x60400046db40>{number = 5, name = (null)}---queue:<OS_dispatch_queue: my queue>
 */
- (void)asyncConcurrent1{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("my queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"---start---, thread: %@", [NSThread currentThread]);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    NSLog(@"---end---, thread: %@", [NSThread currentThread]);
}


/*
 子线程 + 异步执行 + 并行队列

 1. ---start---, thread: <NSThread: 0x604000268480>{number = 3, name = (null)}
 2. ---end---, thread: <NSThread: 0x604000268480>{number = 3, name = (null)}
 3. 任务1---thread:<NSThread: 0x604000269280>{number = 4, name = (null)}---queue:<OS_dispatch_queue: my queue>
 4. 任务2---thread:<NSThread: 0x600000479740>{number = 5, name = (null)}---queue:<OS_dispatch_queue: my queue>
 5. 任务3---thread:<NSThread: 0x600000479300>{number = 6, name = (null)}---queue:<OS_dispatch_queue: my queue>
 */
- (void)asyncConcurrent2 {
    dispatch_queue_t queue = dispatch_queue_create("my queue", DISPATCH_QUEUE_CONCURRENT);
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"---start---, thread: %@", [NSThread currentThread]);
        // 异步调用,  会为queue开启线程, concurrent, 会开启多个线程
        dispatch_async(queue, ^{
            NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_async(queue, ^{
            NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_async(queue, ^{
            NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        NSLog(@"---end---, thread: %@", [NSThread currentThread]);
    }];
}

/*
 主线程 + 异步执行 + 串行队列
 1. ---start---, thread: <NSThread: 0x60000006bd80>{number = 1, name = main}
 2. ---end---, thread: <NSThread: 0x60000006bd80>{number = 1, name = main}
 3. 任务1---thread:<NSThread: 0x60000026bec0>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue2>
 4. 任务2---thread:<NSThread: 0x60000026bec0>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue2>
 5. 任务3---thread:<NSThread: 0x60000026bec0>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue2>
 */
- (void)asyncSerial1{
    //创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("my queue2", DISPATCH_QUEUE_SERIAL);
    NSLog(@"---start---, thread: %@", [NSThread currentThread]);

    // 异步调用, 因此会为这个queue开启新线程, serial只会开启一个线程
    dispatch_async(queue, ^{
        NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    NSLog(@"---end---, thread: %@", [NSThread currentThread]);
}

/*
 子线程 + 异步执行 + 串行队列
 1. ---start---, thread: <NSThread: 0x604000462540>{number = 3, name = (null)}
 2. ---end---, thread: <NSThread: 0x604000462540>{number = 3, name = (null)}
 3. 任务1---thread:<NSThread: 0x604000461e80>{number = 4, name = (null)}---queue:<OS_dispatch_queue: my queue2>
 4. 任务2---thread:<NSThread: 0x604000461e80>{number = 4, name = (null)}---queue:<OS_dispatch_queue: my queue2>
 5. 任务3---thread:<NSThread: 0x604000461e80>{number = 4, name = (null)}---queue:<OS_dispatch_queue: my queue2>
 */
- (void)asyncSerial2{
    //创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("my queue2", DISPATCH_QUEUE_SERIAL);
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"---start---, thread: %@", [NSThread currentThread]);
        // 异步调用, 因此会为这个queue开启新线程, serial只会开启一个线程
        dispatch_async(queue, ^{
            NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_async(queue, ^{
            NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_async(queue, ^{
            NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        NSLog(@"---end---, thread: %@", [NSThread currentThread]);
    }];
}


/*
 主线程 + 同步执行 + 并行队列
 1. ---start---, thread: <NSThread: 0x60000006eb40>{number = 1, name = main}
 2. 任务1---thread:<NSThread: 0x60000006eb40>{number = 1, name = main}---queue:<OS_dispatch_queue: my queue2.1>
 3. 任务2---thread:<NSThread: 0x60000006eb40>{number = 1, name = main}---queue:<OS_dispatch_queue: my queue2.1>
 4. 任务3---thread:<NSThread: 0x60000006eb40>{number = 1, name = main}---queue:<OS_dispatch_queue: my queue2.1>
 5. ---end---, thread: <NSThread: 0x60000006eb40>{number = 1, name = main}
 */
- (void)syncConcurrent1{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("my queue2.1", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"---start---, thread: %@", [NSThread currentThread]);
    dispatch_sync(queue, ^{
        NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    NSLog(@"---end---, thread: %@", [NSThread currentThread]);
}

/*
 子线程 + 同步执行 + 并行队列
 1. ---start---, thread:<NSThread: 0x60000046ba40>{number = 3, name = (null)}
 2. 任务1---thread:<NSThread: 0x60000046ba40>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue2.2>
 3. 任务2---thread:<NSThread: 0x60000046ba40>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue2.2>
 4. 任务3---thread:<NSThread: 0x60000046ba40>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue2.2>
 5. ---end---, thread: <NSThread: 0x60000046ba40>{number = 3, name = (null)}
 */
- (void)syncConcurrent2{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("my queue2.2", DISPATCH_QUEUE_CONCURRENT);
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"---start---, thread:%@", [NSThread currentThread]);
        //使用同步函数封装三个任务
        dispatch_sync(queue, ^{
            NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_sync(queue, ^{
            NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_sync(queue, ^{
            NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
        });

        NSLog(@"---end---, thread: %@", [NSThread currentThread]);
    }];
}

/*
 主线程 + 同步执行 + 串行队列

 1. ---start---, thread:<NSThread: 0x600000076c40>{number = 1, name = main}
 2. 任务1---thread:<NSThread: 0x600000076c40>{number = 1, name = main}---queue:<OS_dispatch_queue: my queue3.1>
 3. 任务2---thread:<NSThread: 0x600000076c40>{number = 1, name = main}---queue:<OS_dispatch_queue: my queue3.1>
 4. 任务3---thread:<NSThread: 0x600000076c40>{number = 1, name = main}---queue:<OS_dispatch_queue: my queue3.1>
 5. ---end---, thread: <NSThread: 0x600000076c40>{number = 1, name = main}
 */
- (void)syncSerial1{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("my queue3.1", DISPATCH_QUEUE_SERIAL);
    // 创建一个子线程, 然后去 同步执行+ 并行队列
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    //使用同步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    NSLog(@"---end---, thread: %@", [NSThread currentThread]);
}


/*
 子线程 + 同步执行 + 串行队列
 1. ---start---, thread:<NSThread: 0x604000273180>{number = 3, name = (null)}
 2. 任务1---thread:<NSThread: 0x604000273180>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue3.1>
 3. 任务2---thread:<NSThread: 0x604000273180>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue3.1>
 4. 任务3---thread:<NSThread: 0x604000273180>{number = 3, name = (null)}---queue:<OS_dispatch_queue: my queue3.1>
 5. ---end---, thread: <NSThread: 0x604000273180>{number = 3, name = (null)}
 */
- (void)syncSerial2{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("my queue3.1", DISPATCH_QUEUE_SERIAL);
    // 创建一个子线程, 然后去 同步执行+ 并行队列
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"---start---, thread:%@", [NSThread currentThread]);
        //使用同步函数封装三个任务
        dispatch_sync(queue, ^{
            NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_sync(queue, ^{
            NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_sync(queue, ^{
            NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
        });

        NSLog(@"---end---, thread: %@", [NSThread currentThread]);
    }];
}

/*
 主线程 + 同步执行 + mainQueue

 结果死锁
 */
- (void)syncInMainQueue1{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建一个子线程, 然后去 同步执行+ 并行队列
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    //使用同步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    NSLog(@"---end---, thread: %@", [NSThread currentThread]);
}

/*
 子线程中 + 同步 + mainQueue

 1. ---start---, thread:<NSThread: 0x600000267100>{number = 3, name = (null)}
 2. 任务1---thread:<NSThread: 0x600000068880>{number = 1, name = main}---queue:<OS_dispatch_queue_main: com.apple.main-thread>
 3. 任务2---thread:<NSThread: 0x600000068880>{number = 1, name = main}---queue:<OS_dispatch_queue_main: com.apple.main-thread>
 4. 任务3---thread:<NSThread: 0x600000068880>{number = 1, name = main}---queue:<OS_dispatch_queue_main: com.apple.main-thread>
 5. ---end---, thread: <NSThread: 0x600000267100>{number = 3, name = (null)}
 */
- (void)syncInMainQueue2{
    //创建一个并行队列
    [NSThread detachNewThreadWithBlock:^{
        //创建一个并行队列
        dispatch_queue_t queue = dispatch_get_main_queue();
        // 创建一个子线程, 然后去 同步执行+ 并行队列
        NSLog(@"---start---, thread:%@", [NSThread currentThread]);
        //使用同步函数封装三个任务
        dispatch_sync(queue, ^{
            NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_sync(queue, ^{
            NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        dispatch_sync(queue, ^{
            NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        NSLog(@"---end---, thread: %@", [NSThread currentThread]);
    }];
}

/**
 同步 + 串行队列的死锁

 1. ---start---, thread:<NSThread: 0x604000079300>{number = 1, name = main}
 2. 任务1---thread:<NSThread: 0x604000079300>{number = 1, name = main}---queue:<OS_dispatch_queue: queue>
 3. 死锁!!!!!!!!!!!!!!(不会执行 end)
 */
-(void)deadLockTestSerialQueue{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    // 创建一个子线程, 然后去 同步执行+ 并行队列
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    //使用同步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
        dispatch_sync(queue, ^{
            NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
        });
        NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
    });

    NSLog(@"---end---, thread: %@", [NSThread currentThread]);
}

/**
 1. ---start---, thread:<NSThread: 0x600000260900>{number = 1, name = main}
 2. 任务1---thread:<NSThread: 0x600000260900>{number = 1, name = main}---queue:<OS_dispatch_queue: queue>
 3. 任务2---thread:<NSThread: 0x600000260900>{number = 1, name = main}---queue:<OS_dispatch_queue: queue>
 4. sleep 5s---thread:<NSThread: 0x600000260900>{number = 1, name = main}---queue:<OS_dispatch_queue: queue>
 5. 任务3---thread:<NSThread: 0x600000260900>{number = 1, name = main}---queue:<OS_dispatch_queue: queue>
 6. sleep 5s---thread:<NSThread: 0x600000260900>{number = 1, name = main}---queue:<OS_dispatch_queue: queue>
 7. ---end---, thread: <NSThread: 0x600000260900>{number = 1, name = main}
 */
-(void)deadLockTestConcurrentQueue{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    // 创建一个子线程, 然后去 同步执行+ 并行队列
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    //使用同步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
        dispatch_sync(queue, ^{
            NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
            [NSThread sleepForTimeInterval:5];
            NSLog(@"sleep 5s---thread:%@---queue:%@ ", [NSThread currentThread], queue);
        });
        NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
        [NSThread sleepForTimeInterval:5];
        NSLog(@"sleep 5s---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    NSLog(@"---end---, thread: %@", [NSThread currentThread]);
}

/**
 1. ---start---, thread:<NSThread: 0x604000064680>{number = 1, name = main}
 2. ---end---, thread: <NSThread: 0x604000064680>{number = 1, name = main}
 3. 任务1---thread:<NSThread: 0x604000272900>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue>
 4. 死锁!!!!!!!!!!!!!!
 */
-(void)deadLockTestSerialQueue2{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    // 创建一个子线程, 然后去 同步执行+ 并行队列
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    //使用同步函数封装三个任务
    dispatch_async(queue, ^{
        NSLog(@"任务1---thread:%@---queue:%@", [NSThread currentThread], queue);
        dispatch_sync(queue, ^{
            NSLog(@"任务2---thread:%@---queue:%@", [NSThread currentThread], queue);
            [NSThread sleepForTimeInterval:5];
            NSLog(@"sleep 5s---thread:%@---queue:%@ ", [NSThread currentThread], queue);
        });
        NSLog(@"任务3---thread:%@---queue:%@", [NSThread currentThread], queue);
        [NSThread sleepForTimeInterval:5];
        NSLog(@"sleep 5s---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    NSLog(@"---end---, thread: %@", [NSThread currentThread]);
}



/**
 理论上, 多个 serialQueue queue1,queue2,queue3, dispatch_async到一个并行队列中, 应该是分别在三个thread中并行执行的.但是这里设置 target_queue以后, 三个线程都在number=3的同一个线程中执行.

 多个serial queue在多个线程并行执行  --->   多个serial queue在同一个线程中串行执行

 1. ---start---, thread:<NSThread: 0x60000007f600>{number = 1, name = main}
 2. ---end---, thread:<NSThread: 0x60000007f600>{number = 1, name = main}
 3. 任务1 in:---thread:<NSThread: 0x60400027f380>{number = 3, name = (null)}---queue:<OS_dispatch_queue: test.1>
 4. 任务1 out:---thread:<NSThread: 0x60400027f380>{number = 3, name = (null)}---queue:<OS_dispatch_queue: test.1>
 5. 任务2 in:---thread:<NSThread: 0x60400027f380>{number = 3, name = (null)}---queue:<OS_dispatch_queue: test.2>
 6. 任务2 out:---thread:<NSThread: 0x60400027f380>{number = 3, name = (null)}---queue:<OS_dispatch_queue: test.2>
 7. 任务3 in:---thread:<NSThread: 0x60400027f380>{number = 3, name = (null)}---queue:<OS_dispatch_queue: test.3>
 8. 任务3 out:---thread:<NSThread: 0x60400027f380>{number = 3, name = (null)}---queue:<OS_dispatch_queue: test.3>

  使用场景: 一般都是把一个任务放到一个串行的queue中，如果这个任务被拆分了，被放置到多个串行的queue中，但实际还是需要这个任务同步执行，那么就会有问题，因为多个串行queue之间是并行的。这时候dispatch_set_target_queue将起到作用。(实际上这种类型的需求使用NSOperation更好)

 */
-(void)testTargetQueue1 {

    // 目标队列是 串行队列
    dispatch_queue_t targetQueue = dispatch_queue_create("test.target.queue", DISPATCH_QUEUE_SERIAL);

    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);

    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);

    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    dispatch_async(queue1, ^{
        NSLog(@"任务1 in:---thread:%@---queue:%@", [NSThread currentThread], queue1);
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"任务1 out:---thread:%@---queue:%@", [NSThread currentThread], queue1);
    });
    dispatch_async(queue2, ^{
        NSLog(@"任务2 in:---thread:%@---queue:%@", [NSThread currentThread], queue2);
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"任务2 out:---thread:%@---queue:%@", [NSThread currentThread], queue2);
    });
    dispatch_async(queue3, ^{
        NSLog(@"任务3 in:---thread:%@---queue:%@", [NSThread currentThread], queue3);
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"任务3 out:---thread:%@---queue:%@", [NSThread currentThread], queue3);
    });

    NSLog(@"---end---, thread:%@", [NSThread currentThread]);

}

/**


 1. ---start---, thread:<NSThread: 0x6040000661c0>{number = 1, name = main}
 2. ---end---, thread:<NSThread: 0x6040000661c0>{number = 1, name = main}
 3. 任务1 in:---thread:<NSThread: 0x604000269f40>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue1>
 4. 任务1 in:---thread:<NSThread: 0x604000269f40>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue1>
 5. 任务2 in:---thread:<NSThread: 0x604000269f40>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue1>
 6. 任务2 in:---thread:<NSThread: 0x604000269f40>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue1>
 7. 任务3 in:---thread:<NSThread: 0x604000269f40>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue1>
 8. 任务3 in:---thread:<NSThread: 0x604000269f40>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue1>

 queue1是并行队列, queue2是串行队列.在都设置 串行队列targetQueue作为目标队列以后. 所有的异步调用dispatch_async到queue1, queue2的block, 都好像dispatch_async到targetQueue中执行一样.
 */
- (void)testTargetQueue2 {
    // target-queue是 串行队列
    dispatch_queue_t targetQueue = dispatch_queue_create("targetQueue", DISPATCH_QUEUE_SERIAL);


    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);//串行队列
    dispatch_queue_t queue2 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);//并发队列
    //设置参考, targetQueue是参考队列.
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    // 虽然是异步调用但是是顺序执行.因为targetQueue是serial, 创建队列的层次体系
    dispatch_async(queue1, ^{
        NSLog(@"任务1 in:---thread:%@---queue:%@", [NSThread currentThread], queue1);
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"任务1 in:---thread:%@---queue:%@", [NSThread currentThread], queue1);
    });
    dispatch_async(queue1, ^{
        NSLog(@"任务2 in:---thread:%@---queue:%@", [NSThread currentThread], queue1);
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"任务2 in:---thread:%@---queue:%@", [NSThread currentThread], queue1);
    });
    dispatch_async(queue2, ^{
        NSLog(@"任务3 in:---thread:%@---queue:%@", [NSThread currentThread], queue2);
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"任务3 in:---thread:%@---queue:%@", [NSThread currentThread], queue2);
    });
    NSLog(@"---end---, thread:%@", [NSThread currentThread]);
}

/**
 1 ---start---, thread:<NSThread: 0x60000007b940>{number = 1, name = main}
 2 ---end  1---, thread:<NSThread: 0x600000070840>{number = 1, name = main}

 // 3.1, 3.2 两步是并行执行的
 3.1 任务2 in:---thread:<NSThread: 0x600000275780>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue>
 3.2 任务1 in:---thread:<NSThread: 0x600000275900>{number = 4, name = (null)}---queue:<OS_dispatch_queue: queue>

 // 4 在3.1, 3.2两步执行完成以后才执行,
 4 ---end  2---, thread:<NSThread: 0x600000070840>{number = 1, name = main}


 */
- (void)dispatchGroupWaitDemo1 {
    dispatch_queue_t queue = dispatch_queue_create("queue",DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    // 在group中添加任务block
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"任务1 ---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务2 ---thread:%@---queue:%@", [NSThread currentThread], queue);
    });

    NSLog(@"---end  1---, thread:%@", [NSThread currentThread]);
    // 使用阻塞等待group中的内容执行完成
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"---end  2---, thread:%@", [NSThread currentThread]);
}

/**
 1  ---start---, thread:<NSThread: 0x60400007aa00>{number = 1, name = main}
 2  ---end  1---, thread:<NSThread: 0x60400007aa00>{number = 1, name = main}
 // 3.1, 3.2是并行执行的
 3.1 任务2 ---thread:<NSThread: 0x60400027dac0>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue>
 3.2 任务1 ---thread:<NSThread: 0x604000278b80>{number = 4, name = (null)}---queue:<OS_dispatch_queue: queue>

 // 异步回调notify
 4 ---end  2---, thread:<NSThread: 0x60400007aa00>{number = 1, name = main}

 */
- (void)dispatchGroupWaitDemo2 {
    dispatch_queue_t queue = dispatch_queue_create("queue",DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    // 在group中添加任务block.
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"任务1 ---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务2 ---thread:%@---queue:%@", [NSThread currentThread], queue);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"---end  2---, thread:%@", [NSThread currentThread]);
    });
    NSLog(@"---end  1---, thread:%@", [NSThread currentThread]);
}


/**
 同dispatchGroupWaitDemo2, 只关心加入到group的block, 并不关心queue

 1 ---start---, thread:<NSThread: 0x600000065280>{number = 1, name = main}
 2 ---end  1---, thread:<NSThread: 0x600000065280>{number = 1, name = main}
 3.1 任务1 ---thread:<NSThread: 0x60400026d780>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue1>
 3.2 任务2 ---thread:<NSThread: 0x600000076080>{number = 4, name = (null)}---queue:<OS_dispatch_queue: queue2>
 4 ---end  2---, thread:<NSThread: 0x600000065280>{number = 1, name = main}

 */
- (void)dispatchGroupWaitDemo3 {
    dispatch_queue_t queue1 = dispatch_queue_create("queue1",DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2",DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_t group = dispatch_group_create();
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    // 在group中添加任务block.
    dispatch_group_async(group, queue1, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"任务1 ---thread:%@---queue:%@", [NSThread currentThread], queue1);
    });
    dispatch_group_async(group, queue2, ^{
        [NSThread sleepForTimeInterval:5.f];
        NSLog(@"任务2 ---thread:%@---queue:%@", [NSThread currentThread], queue2);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"---end  2---, thread:%@", [NSThread currentThread]);
    });
    NSLog(@"---end  1---, thread:%@", [NSThread currentThread]);
}

/**
 1. ---start---, thread:<NSThread: 0x600000071d40>{number = 1, name = main}
 2. ---end  1---, thread:<NSThread: 0x600000071d40>{number = 1, name = main}
 3.1 任务1 ---thread:<NSThread: 0x60400026d100>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue1>
 3.2 任务2 ---thread:<NSThread: 0x600000461740>{number = 4, name = (null)}---queue:<OS_dispatch_queue: queue2>
 4. ---end  2---, thread:<NSThread: 0x600000071d40>{number = 1, name = main}

 */
- (void)dispatchGroupWaitDemo4 {

    dispatch_queue_t queue1 = dispatch_queue_create("queue1",DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2",DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_t group = dispatch_group_create();
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);

    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"任务1 ---thread:%@---queue:%@", [NSThread currentThread], queue1);
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:5.f];
        NSLog(@"任务2 ---thread:%@---queue:%@", [NSThread currentThread], queue2);
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"---end  2---, thread:%@", [NSThread currentThread]);
    });
    NSLog(@"---end  1---, thread:%@", [NSThread currentThread]);
}

/**
 1. ---start---, thread:<NSThread: 0x600000261000>{number = 1, name = main}
 2. ---end  1---, thread:<NSThread: 0x600000261000>{number = 1, name = main}
 3.1 任务3 ---thread:<NSThread: 0x600000464400>{number = 3, name = (null)}---queue:<OS_dispatch_queue: queue2>
 3.2 任务1 ---thread:<NSThread: 0x600000465000>{number = 4, name = (null)}---queue:<OS_dispatch_queue: queue1>
 3.3 任务2 ---thread:<NSThread: 0x600000467400>{number = 5, name = (null)}---queue:<OS_dispatch_queue: queue2>
 4. ---end  2---, thread:<NSThread: 0x600000261000>{number = 1, name = main}
 */
- (void)dispatchGroupWaitDemo5 {

    dispatch_queue_t queue1 = dispatch_queue_create("queue1",DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2",DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_t group = dispatch_group_create();
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);

    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"任务1 ---thread:%@---queue:%@", [NSThread currentThread], queue1);
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);

    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:5.f];
        NSLog(@"任务2 ---thread:%@---queue:%@", [NSThread currentThread], queue2);
        dispatch_group_leave(group);
    });

    dispatch_group_async(group, queue2, ^{
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"任务3 ---thread:%@---queue:%@", [NSThread currentThread], queue2);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"---end  2---, thread:%@", [NSThread currentThread]);
    });
    NSLog(@"---end  1---, thread:%@", [NSThread currentThread]);
}

- (void)dispatchGroupWaitDemo6 {
    dispatch_queue_t queue1 = dispatch_queue_create("queue1",DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2",DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_t group = dispatch_group_create();
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);

    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"任务1 ---thread:%@---queue:%@", [NSThread currentThread], queue1);
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);

    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:5.f];
        NSLog(@"任务2 ---thread:%@---queue:%@", [NSThread currentThread], queue2);
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"---end  2---, thread:%@", [NSThread currentThread]);
    });

    dispatch_group_async(group, queue2, ^{
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"任务3 ---thread:%@---queue:%@", [NSThread currentThread], queue2);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"---end  3---, thread:%@", [NSThread currentThread]);

    });

    NSLog(@"---end  1---, thread:%@", [NSThread currentThread]);
}


/**
 2018-07-04 14:42:32.529311+0800 pthreadDemo[56921:5025231] ---start---, thread:<NSThread: 0x60400007afc0>{number = 1, name = main}
 2018-07-04 14:42:32.529587+0800 pthreadDemo[56921:5025231] ---end---, thread:<NSThread: 0x60400007afc0>{number = 1, name = main}
 2018-07-04 14:42:34.534769+0800 pthreadDemo[56921:5025445] 2---<NSThread: 0x600000462ac0>{number = 3, name = (null)}
 2018-07-04 14:42:34.534782+0800 pthreadDemo[56921:5025447] 1---<NSThread: 0x600000462e40>{number = 4, name = (null)}
 2018-07-04 14:42:36.538536+0800 pthreadDemo[56921:5025445] 2---<NSThread: 0x600000462ac0>{number = 3, name = (null)}
 2018-07-04 14:42:36.538536+0800 pthreadDemo[56921:5025447] 1---<NSThread: 0x600000462e40>{number = 4, name = (null)}
 2018-07-04 14:42:38.540485+0800 pthreadDemo[56921:5025447] barrier---<NSThread: 0x600000462e40>{number = 4, name = (null)}
 2018-07-04 14:42:40.543862+0800 pthreadDemo[56921:5025447] barrier---<NSThread: 0x600000462e40>{number = 4, name = (null)}
 2018-07-04 14:42:42.545779+0800 pthreadDemo[56921:5025445] 4---<NSThread: 0x600000462ac0>{number = 3, name = (null)}
 2018-07-04 14:42:42.545780+0800 pthreadDemo[56921:5025447] 3---<NSThread: 0x600000462e40>{number = 4, name = (null)}
 2018-07-04 14:42:44.547830+0800 pthreadDemo[56921:5025447] 3---<NSThread: 0x600000462e40>{number = 4, name = (null)}
 2018-07-04 14:42:44.547830+0800 pthreadDemo[56921:5025445] 4---<NSThread: 0x600000462ac0>{number = 3, name = (null)}

 */
- (void)dispatchBarrierAsyncDemo {
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });

    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });

    NSLog(@"---end---, thread:%@", [NSThread currentThread]);

}

/**
 2018-07-04 16:20:47.179561+0800 pthreadDemo[64925:5298793] ---start---, thread:<NSThread: 0x60400006ef80>{number = 1, name = main}
 2018-07-04 16:20:49.184556+0800 pthreadDemo[64925:5299137] 1---<NSThread: 0x60400046dc40>{number = 4, name = (null)}
 2018-07-04 16:20:49.184557+0800 pthreadDemo[64925:5299136] 2---<NSThread: 0x60000007c000>{number = 3, name = (null)}
 2018-07-04 16:20:51.187729+0800 pthreadDemo[64925:5299137] 1---<NSThread: 0x60400046dc40>{number = 4, name = (null)}
 2018-07-04 16:20:51.187769+0800 pthreadDemo[64925:5299136] 2---<NSThread: 0x60000007c000>{number = 3, name = (null)}
 2018-07-04 16:20:51.188237+0800 pthreadDemo[64925:5298793] ---end---, thread:<NSThread: 0x60400006ef80>{number = 1, name = main}
 2018-07-04 16:20:53.193472+0800 pthreadDemo[64925:5299136] 4---<NSThread: 0x60000007c000>{number = 3, name = (null)}
 2018-07-04 16:20:53.193472+0800 pthreadDemo[64925:5299137] 3---<NSThread: 0x60400046dc40>{number = 4, name = (null)}
 2018-07-04 16:20:55.199081+0800 pthreadDemo[64925:5299137] 3---<NSThread: 0x60400046dc40>{number = 4, name = (null)}
 2018-07-04 16:20:55.199085+0800 pthreadDemo[64925:5299136] 4---<NSThread: 0x60000007c000>{number = 3, name = (null)}

 */
-(void)dispatchBlockDemo1{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"---start---, thread:%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });

    // 创建一个 barrier block
    dispatch_block_t block = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    dispatch_async(queue,block);

    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });

    dispatch_block_cancel(block);
    dispatch_block_wait(block, DISPATCH_TIME_FOREVER);

    NSLog(@"---end---, thread:%@", [NSThread currentThread]);
}


/**
 1. 0---<NSThread: 0x60000006d0c0>{number = 1, name = main}
 2. 1---<NSThread: 0x600000276180>{number = 4, name = (null)}
 3. 2---<NSThread: 0x600000276200>{number = 3, name = (null)}
 4. 3---<NSThread: 0x6040002783c0>{number = 5, name = (null)}
 5. 4---<NSThread: 0x600000276180>{number = 4, name = (null)}
 6. The end
 */
- (void)dispatchApplyDemo {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(5, concurrentQueue, ^(size_t i) {
        NSLog(@"%zu---%@",i,[NSThread currentThread]);
    });
    NSLog(@"The end"); //这里有个需要注意的是，dispatch_apply这个是会阻塞主线程的。这个log打印会在dispatch_apply都结束后才开始执行
}

/**
 1. start--- 1 <NSThread: 0x60000007dd80>{number = 1, name = main}
 2 start--- 2 <NSThread: 0x60000027d440>{number = 3, name = (null)}
 3 semaphore +1---<NSThread: 0x60000027d440>{number = 3, name = (null)}
 4 continue---<NSThread: 0x60000007dd80>{number = 1, name = main}

 */
- (void)dispatchSemaphoreDemo {
    //创建semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSLog(@"start--- 1 %@", [NSThread currentThread]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start--- 2 %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"semaphore +1---%@", [NSThread currentThread]);
        dispatch_semaphore_signal(semaphore); //+1 semaphore
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"continue---%@", [NSThread currentThread]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dispatchSemaphoreDemo];
}
@end
