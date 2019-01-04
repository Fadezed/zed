CREATE TABLE blog.t_attach
(
    id int(11) unsigned PRIMARY KEY NOT NULL AUTO_INCREMENT,
    fname varchar(100) DEFAULT '' NOT NULL,
    ftype varchar(50) DEFAULT '',
    fkey varchar(100) DEFAULT '' NOT NULL,
    author_id int(10),
    created int(10) NOT NULL
);

CREATE TABLE blog.t_comments
(
    coid int(10) unsigned PRIMARY KEY NOT NULL AUTO_INCREMENT,
    cid int(10) unsigned DEFAULT '0',
    created int(10) unsigned DEFAULT '0',
    author varchar(200),
    author_id int(10) unsigned DEFAULT '0',
    owner_id int(10) unsigned DEFAULT '0',
    mail varchar(200),
    url varchar(200),
    ip varchar(64),
    agent varchar(200),
    content text,
    type varchar(16) DEFAULT 'comment',
    status varchar(16) DEFAULT 'approved',
    parent int(10) unsigned DEFAULT '0'
);
CREATE INDEX cid ON blog.t_comments (cid);
CREATE INDEX created ON blog.t_comments (created);

CREATE TABLE blog.t_contents
(
    cid int(10) unsigned PRIMARY KEY NOT NULL AUTO_INCREMENT,
    title varchar(200),
    slug varchar(200),
    created int(10) unsigned DEFAULT '0',
    modified int(10) unsigned DEFAULT '0',
    content text COMMENT '内容文字',
    author_id int(10) unsigned DEFAULT '0',
    type varchar(16) DEFAULT 'post',
    status varchar(16) DEFAULT 'publish',
    tags varchar(200),
    categories varchar(200),
    hits int(10) unsigned DEFAULT '0',
    comments_num int(10) unsigned DEFAULT '0',
    allow_comment tinyint(1) DEFAULT '1',
    allow_ping tinyint(1) DEFAULT '1',
    allow_feed tinyint(1) DEFAULT '1'
);
CREATE UNIQUE INDEX slug ON blog.t_contents (slug);
CREATE INDEX created ON blog.t_contents (created);
INSERT INTO blog.t_contents (cid, title, slug, created, modified, content, author_id, type, status, tags, categories, hits, comments_num, allow_comment, allow_ping, allow_feed) VALUES (1, 'about my blog', 'about', 1487853610, 1546585038, '@遮天', 1, 'page', 'publish', null, null, 59, 0, 1, 1, 1);
INSERT INTO blog.t_contents (cid, title, slug, created, modified, content, author_id, type, status, tags, categories, hits, comments_num, allow_comment, allow_ping, allow_feed) VALUES (3, '《Java 多线程编程核心技术》学习笔记及总结', 'Java-Thread', 1497322995, 1497323171, '## 第一章 —— Java 多线程技能

线程技术点：

+ 线程的启动
+ 如何使线程暂停
+ 如何使线程停止
+ 线程的优先级
+ 线程安全相关问题
<!-- more -->
### 进程和线程的概念及多线程的优点

进程：比如我们电脑运行的 QQ.exe 程序，是操作系统管理的基本运行单元

线程：在进程中独立运行的子任务，比如 QQ.exe 进程中就有很多线程在运行，下载文件线程、发送消息线程、语音线程、视频线程等。

多线程优点：我们电脑可以同时操作不同的软件，边听着歌，敲着代码，查看 pdf 文档，浏览网页等，CPU 在这些任务之间不停的切换，切换非常快，所以我们就觉得他们是在同时运行的。

### 使用多线程

#### 继承 Thread 类

JDK 源码注释（Thread.java）如下：

```java
One is to declare a class to be a subclass(子类) of <code>Thread</code>. This subclass should override the <code>run</code> method of class <code>Thread</code>. An instance of the subclass can then be allocated and started. For example, a thread that computes primes
larger than a stated value could be written as follows:
//继承 Thread 类
class PrimeThread extends Thread {
         long minPrime;
         PrimeThread(long minPrime) {
          this.minPrime = minPrime;
         }

         public void run() {
             // compute primes larger than minPrime
             重写 Thread 类的 run 方法
          }
     }

The following code would then create a thread and start it running:
//开启线程
    PrimeThread p = new PrimeThread(143);
    p.start();
```

#### 实现 Runnable 接口

JDK 源码注释（Thread.java）如下：

```java
The other way to create a thread is to declare a class that implements the <code>Runnable</code> interface. That class then implements the <code>run</code> method. An instance of the class can then be allocated, passed as an argument when creating
<code>Thread</code>, and started. The same example in this other style looks like the following:
//实现 Runnable 接口
    class PrimeRun implements Runnable {
        long minPrime;
        PrimeRun(long minPrime) {
            this.minPrime = minPrime;
         }

         public void run() {
            // compute primes larger than minPrime
            //重写 run 方法
        }
    }

The following code would then create a thread and start it running:
//开启线程
     PrimeRun p = new PrimeRun(143);
     new Thread(p).start();
```



### currentThread() 方法

该方法返回代码段正在被哪个线程调用的信息。

### isAlive() 方法

判断当前线程是否处于活动状态（已经启动但未终止）

### sleep() 方法

在指定的毫秒数内让当前“正在执行的线程（this.currentThread() 返回的线程）”休眠（暂停执行）。

### getId() 方法

获取线程的唯一标识

### 停止线程

可以使用 <del>Thread.stop()</del> 方法，但最好不要用，因为这个方法是不安全的，已经弃用作废了。

大多数停止一个线程是使用 Thread.interrupt() 方法

#### 判断线程是否是停止状态

+    interrupted()
```java
     //测试当前线程是否已经中断了，这个线程的中断状态会被这个方法清除。
     //换句话说，如果连续两次调用了这个方法，第二次调用的时候将会返回 false ，
     public static boolean interrupted() {
             return currentThread().isInterrupted(true);
     }
```

+    isInterrupted()

```java
        //测试线程是否已经中断了，线程的状态不会受这个方法的影响
        //线程中断被忽略，因为线程处于中断下不处于活动状态的线程由此返回false的方法反映出来
         public boolean isInterrupted() {
                return isInterrupted(false);
        }
        /**
     * Tests if some Thread has been interrupted.  The interrupted state
     * is reset or not based on the value of ClearInterrupted that is
     * passed.
     */
     private native boolean isInterrupted(boolean ClearInterrupted);
```

#### 在沉睡中停止

```java
public class MyThread2 extends Thread
{
    @Override
    public void run() {
        try {
            System.out.println("run start");
            Thread.sleep(20000);
            System.out.println("run end");
        } catch (InterruptedException e) {
            System.out.println("run catch "+this.isInterrupted());
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        try {
            MyThread2 t2 = new MyThread2();
            t2.start();
            Thread.sleep(200);
            t2.interrupt();
        } catch (InterruptedException e) {
            System.out.println("main catch");
            e.printStackTrace();
        }
        System.out.println("main end");
    }
}
```

运行结果：

```java
run start
main end
run catch false
java.lang.InterruptedException: sleep interrupted
	at java.lang.Thread.sleep(Native Method)
	at com.zhisheng.thread.thread1.MyThread2.run(MyThread2.java:12)
```

从运行结果来看，如果在 sleep 状态下停止某一线程，会进入 catch 语句，并清除停止状态值，使之变成 false。

#### 在停止中沉睡

```java
public class MyThread3 extends Thread
{
    @Override
    public void run() {
        try {
            System.out.println("run start");
            Thread.sleep(20000);
            System.out.println("run end");
        } catch (InterruptedException e) {
            System.out.println("run catch "+this.isInterrupted());
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
            MyThread3 t3 = new MyThread3();
            t3.start();
            t3.interrupt();
    }
}
```

运行结果：

```java
run start
run catch false
java.lang.InterruptedException: sleep interrupted
	at java.lang.Thread.sleep(Native Method)
	at com.zhisheng.thread.thread1.MyThread3.run(MyThread3.java:12)
```

#### 能停止的线程 —— 暴力停止

使用 stop() 方法停止线程

### 暂停线程

可使用 suspend 方法暂停线程，使用 resume() 方法恢复线程的执行。

#### suspend 和 resume 方法的使用

```java
public class MyThread4 extends Thread
{
    private int i;
    public int getI() {
        return i;
    }
    public void setI(int i) {
        this.i = i;
    }
    @Override
    public void run() {
        while (true) {
            i++;
        }
    }
    public static void main(String[] args) throws InterruptedException {
        MyThread4 t4 = new MyThread4();
        t4.start();
        System.out.println("A----- " + System.currentTimeMillis() + " ---- " + t4.getI());
        Thread.sleep(2000);
        System.out.println("A----- " + System.currentTimeMillis() + " ---- " + t4.getI());
        t4.suspend();
        Thread.sleep(2000);
        t4.resume();
        System.out.println("B----- " + System.currentTimeMillis() + " ---- " + t4.getI());
        Thread.sleep(2000);
        System.out.println("B----- " + System.currentTimeMillis() + " ---- " + t4.getI());
    }
}
```

从运行结果来看，线程的确能够暂停和恢复。

但是 suspend 和 resume 方法的缺点就是：**不同步**，因为线程的暂停导致数据的不同步。

### yield 方法

```java
/**
     * A hint to the scheduler that the current thread is willing to yield
     * its current use of a processor. The scheduler is free to ignore this
     * hint.
     *
     * <p> Yield is a heuristic attempt to improve relative progression
     * between threads that would otherwise over-utilise a CPU. Its use
     * should be combined with detailed profiling and benchmarking to
     * ensure that it actually has the desired effect.
     *
     * <p> It is rarely appropriate to use this method. It may be useful
     * for debugging or testing purposes, where it may help to reproduce
     * bugs due to race conditions. It may also be useful when designing
     * concurrency control constructs such as the ones in the
     * {@link java.util.concurrent.locks} package.
     */
    //暂停当前正在执行的线程对象，并执行其他线程。暂停的时间不确定。
    public static native void yield();
```

```java
public class MyThread5 extends Thread
{
    @Override
    public void run() {
        double start = System.currentTimeMillis();
        for (int i = 0; i < 200000; i++) {
            //yield();//暂停的时间不确定
            i++;
        }
        double end = System.currentTimeMillis();
        System.out.println("time is "+(end - start));
    }
    public static void main(String[] args) {
        MyThread5  t5 = new MyThread5();
        t5.start();
    }
}
```

### 线程的优先级

设置优先级的方法：setPriority() 方法

```java
public final void setPriority(int newPriority) {
        ThreadGroup g;
        checkAccess();
        if (newPriority > MAX_PRIORITY || newPriority < MIN_PRIORITY) {
            throw new IllegalArgumentException();
        }
        if((g = getThreadGroup()) != null) {
            if (newPriority > g.getMaxPriority()) {
                newPriority = g.getMaxPriority();
            }
            setPriority0(priority = newPriority);
        }
    }
```

不一定优先级高的线程就先执行。

### 守护线程

当进程中不存在非守护线程了，则守护线程自动销毁。垃圾回收线程就是典型的守护线程，当进程中没有非守护线程了，则垃圾回收线程也就没有存在的必要了，自动销毁。

```java
 /**
     * Marks this thread as either a {@linkplain #isDaemon daemon} thread
     * or a user thread. The Java Virtual Machine exits when the only
     * threads running are all daemon threads.
     *
     * <p> This method must be invoked before the thread is started.
     *
     * @param  on
     *         if {@code true}, marks this thread as a daemon thread
     * @throws  IllegalThreadStateException
     *          if this thread is {@linkplain #isAlive alive}
     * @throws  SecurityException
     *          if {@link #checkAccess} determines that the current
     *          thread cannot modify this thread
     */
    public final void setDaemon(boolean on) {
        checkAccess();
        if (isAlive()) {
            throw new IllegalThreadStateException();
        }
        daemon = on;
    }
```





## 第二章 —— 对象及变量的并发访问

技术点：

+ synchronized 对象监视器为 Object 时的使用
+ synchronized 对象监视器为 Class 时的使用
+ 非线程安全是如何出现的
+ 关键字 volatile 的主要作用
+ 关键字 volatile 与 synchronized 的区别及使用情况

### synchronized 同步方法

#### 方法内的变量为线程安全

“非线程安全”问题存在于“实例变量”中，如果是方法内部的私有变量，则不存在“非线程安全”问题，所得结果也就是“线程安全”了。

#### 实例变量非线程安全

如果多线程共同访问一个对象中的实例变量，则有可能出现“非线程安全”问题。

在两个线程访问同一个对象中的同步方法时一定是线程安全的。

#### 脏读

发生脏读的情况是在读取实例变量时，此值已经被其他线程更改过了。

如下例子就可以说明，如果不加 synchronized 关键字在 setValue 和 getValue 方法上，就会出现数据脏读。

```java
class VarName
{
    private String userName = "A";
    private String password = "AA";
    synchronized public void setValue(String userName, String password) {
        try {
            this.userName = userName;
            Thread.sleep(500);
            this.password = password;
            System.out.println("setValue method Thread name is :  " + Thread.currentThread().getName() + " userName = " + userName + " password = " + password);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    //synchronized
    public void getValue() {
        System.out.println("getValue method Thread name is :  " + Thread.currentThread().getName() + " userName = " + userName + " password = " + password);
    }
}

class Thread1 extends Thread
{
    private VarName varName;
    public Thread1(VarName varName) {
        this.varName = varName;
    }
    @Override
    public void run() {
        varName.setValue("B", "BB");
    }
}

public class Test
{
    public static void main(String[] args) throws InterruptedException {
        VarName v = new VarName();
        Thread1 thread1 = new Thread1(v);
        thread1.start();
        Thread.sleep(200);//打印结果受睡眠时间的影响
        v.getValue();
    }
}
```

#### synchronized 锁重入

关键字 synchronized 拥有锁重入的功能，也就是在使用 synchronized 时，当一个线程得到一个对象锁后，再次请求此对象锁是可以再次得到该对象的锁的。这也证明了在一个 synchronized 方法/块的内部调用本类的其他 synchronized 方法/块时，是永远可以得到锁的。

```java
class Service
{
    synchronized public void service1() {
        System.out.println("service 1");
        service2();
    }
    synchronized public void service2() {
        System.out.println("service 2");
        service3();
    }
    synchronized public void service3() {
        System.out.println("service 3");
    }
}

class Thread2 extends Thread
{
    @Override
    public void run() {
        Service s = new Service();
        s.service1();
    }
}

public class Test2
{
    public static void main(String[] args) {
        Thread2 t2 = new Thread2();
        t2.start();
    }
}
```

运行结果：

```
service 1
service 2
service 3
```

#### 同步不具有继承性

同步不可以继承。

### synchronized 同步语句块

#### synchronized 代码块间的同步性

当一个线程访问 object 的一个 synchronized(this) 同步代码块时，其他线程对同一个 object 中所有其他 synchronized(this) 同步代码块的访问将被阻塞，这说明 synchronized 使用的 “对象监视器” 是一个。

#### 将任意对象作为对象监视器

多个线程调用同一个对象中的不同名称的 synchronized 同步方法或者 synchronized(this) 同步代码块时，调用的效果就是按顺序执行，也就是同步的，阻塞的。

#### 静态同步 synchronized 方法与  synchronized(class) 代码块

关键字 synchronized 还可以应用在 static 静态方法上，如果这样写就是对当前的 *.java 文件对应的 Class 类进行加锁。而 synchronized 关键字加到非 static 静态方法上就是给对象加锁。

#### 多线程的死锁



### volatile 关键字

作用：使变量在多个线程间可见。

通过使用 volatile 关键字，强制的从公共内存中读取变量的值。使用 volatile 关键字增加了实例变量在多个线程之间的可见性，但 volatile 关键字最致命的缺点就是不支持原子性。

关键字 synchronized 和 volatile 比较：

+ 关键字 volatile 是线程同步的轻量实现，所以 volatile 性能肯定要比 synchronized 要好，并且 volatile 只能修饰于变量，而 synchronized 可以修饰方法，以及代码块。

+ 多线程访问 volatile 不会发生阻塞，而 synchronized 会出现阻塞。

+ volatile 能保证数据的可见性，但不能保证原子性；而 synchronized 可以保证原子性，也可以间接保证可见性，因为它会将私有内存和公有内存中的数据做同步。

+ 关键字 volatile 解决的是变量在多个线程之间的可见性；而 synchronized 关键字解决的是多个线程之间访问资源的同步性。

  ​



## 第三章 —— 线程间通信

技术点：

+ 使用 wait/notify 实现线程间的通信
+ 生产者/消费者模式的实现
+ 方法 join 的使用
+ ThreadLocal 类的使用


### 等待/通知机制

wait 使线程停止运行，notify 使停止的线程继续运行。

关键字 synchronized 可以将任何一个 Object 对象作为同步对象看待，而 Java 为每个 Object 都实现了 wait() 和 notify() 方法，他们必须用在被 synchronized 同步的 Object 的临界区内。通过调用 wait 方法可以使处于临界区内的线程进入等待状态，同时释放被同步对象的锁。而 notify 操作可以唤醒一个因调用了 wait 方法而处于阻塞状态的线程，使其进入就绪状态。被重新唤醒的线程会试图重新获得临界区的控制权，继续执行临界区内 wait 之后的代码。

wait 方法可以使调用该方法的线程释放共享资源的锁，从运行状态退出，进入等待状态，直到再次被唤醒。

notify() 方法可以随机唤醒等待对列中等待同一共享资源的一个线程，并使该线程退出等待状态，进入可运行状态。

notifyAll() 方法可以随机唤醒等待对列中等待同一共享资源的所有线程，并使这些线程退出等待状态，进入可运行状态。

#### 线程状态示意图：

![](http://ohfk1r827.bkt.clouddn.com/thread-state.jpg)

+ 新创建一个线程对象后，在调用它的 start() 方法，系统会为此线程分配 CPU 资源，使其处于 Runnable（可运行）状态，如果线程抢占到 CPU 资源，此线程就会处于 Running （运行）状态

+ Runnable 和 Running 状态之间可以相互切换，因为线程有可能运行一段时间后，有其他优先级高的线程抢占了 CPU 资源，此时线程就从 Running 状态变成了 Runnable 状态。

  线程进入 Runnable 状态有如下几种情况：

  + 调用 sleep() 方法后经过的时间超过了指定的休眠时间
  + 线程调用的阻塞 IO 已经返回，阻塞方法执行完毕
  + 线程成功的获得了试图同步的监视器
  + 线程正在等待某个通知，其他线程发出了通知
  + 处于挂状态的线程调用了 resume 恢复方法

+ Blocked 是阻塞的意思，例如线程遇到一个 IO 操作，此时 CPU 处于空闲状态，可能会转而把 CPU 时间片分配给其他线程，这时也可以称为 “暂停”状态。Blocked 状态结束之后，进入 Runnable 状态，等待系统重新分配资源。

  出现阻塞状态的有如下几种情况：

  + 线程调用 sleep 方法，主动放弃占用的处理器资源
  + 线程调用了阻塞式 IO 方法，在该方法返回之前，该线程被阻塞
  + 线程试图获得一个同步监视器，但该同步监视器正在被其他线程所持有
  + 线程等待某个通知
  + 程序调用了 suspend 方法将该线程挂起

+ run 方法运行结束后进入销毁阶段，整个线程执行完毕。

#### 生产者/消费者模式实现

一个生产者，一个消费者

存储值对象：

```java
package com.zhisheng.thread.thread5;

/**
 * Created by 10412 on 2017/6/3.
 * 存储值对象
 */
public class ValueObject
{
    public static String value = "";
}
```

生产者：

```java
package com.zhisheng.thread.thread5;

/**
 * Created by 10412 on 2017/6/3.
 * 生产者
 */
public class Product
{
    private String lock;

    public Product(String lock) {
        this.lock = lock;
    }

    public void setValue() {
        synchronized (lock) {
            if (!ValueObject.value.equals("")) {
                try {
                    lock.wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            String value = System.currentTimeMillis() + "_" + System.nanoTime();
            System.out.println("生产者 set 的值是：" + value);
            ValueObject.value = value;
            lock.notify();
        }
    }
}
```

消费者：

```java
package com.zhisheng.thread.thread5;

/**
 * Created by 10412 on 2017/6/3.
 * 消费者
 */
public class Resume
{
    private String lock;

    public Resume(String lock) {
        this.lock = lock;
    }

    public void getValue() {
        synchronized (lock) {
            if (ValueObject.value.equals("")) {
                try {
                    lock.wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            System.out.println("消费者 get 的值：" + ValueObject.value);
            ValueObject.value = "";
            lock.notify();
        }
    }
}
```

生产者线程：

```java
package com.zhisheng.thread.thread5;

/**
 * Created by 10412 on 2017/6/3.
 * 生产者线程
 */
public class ProductThread extends Thread
{
    private Product p;

    public ProductThread(Product p) {
        this.p = p;
    }

    @Override
    public void run() {
        while (true) {
            p.setValue();
        }
    }
}
```

消费者线程：

```java
package com.zhisheng.thread.thread5;

/**
 * Created by 10412 on 2017/6/3.
 * 消费者线程
 */
public class ResumeThread extends Thread
{
    private Resume r;

    public ResumeThread(Resume r) {
        this.r = r;
    }

    @Override
    public void run() {
        while (true) {
            r.getValue();
        }
    }
}
```

主函数：

```java
package com.zhisheng.thread.thread5;

/**
 * Created by 10412 on 2017/6/3.
 * 一个生产者一个消费者测试
 */
public class Test
{
    public static void main(String[] args) {
        String str = new String("");
        Product p = new Product(str);
        Resume r = new Resume(str);;
        ProductThread pt = new ProductThread(p);
        ResumeThread rt = new ResumeThread(r);
        pt.start();
        rt.start();
    }
}
```

题目：创建20个线程，其中10个线程是将数据备份到数据库A，另外10个线程将数据备份到数据库B中去，并且备份数据库A和备份数据库B是交叉进行的。

工具类：

```java
package com.zhisheng.thread.thread6;

/**
 * Created by 10412 on 2017/6/3.
 * 创建20个线程，其中10个线程是将数据备份到数据库A，另外10个线程将数据备份到数据库B中去，并且
 * 备份数据库A和备份数据库B是交叉进行的
 */
public class DBTools
{
    volatile private boolean prevIsA = false;

    //确保A备份先进行
    synchronized public void backA() {
        while (prevIsA == true) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        for (int i = 0; i < 5; i++) {
            System.out.println("AAAAA");
        }
        prevIsA = true;
        notifyAll();
    }

    synchronized public void backB() {
        while (prevIsA == false) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        for (int i = 0; i < 5; i++) {
            System.out.println("BBBBB");
        }
        prevIsA = false;
        notifyAll();
    }
}
```

备份A先线程：

```java
package com.zhisheng.thread.thread6;

/**
 * Created by 10412 on 2017/6/3.
 */
public class ThreadA extends Thread
{
    private DBTools dbTools;

    public ThreadA(DBTools dbTools) {
        this.dbTools = dbTools;
    }

    @Override
    public void run() {
        dbTools.backA();
    }
}
```

备份B线程：

```java
package com.zhisheng.thread.thread6;

/**
 * Created by 10412 on 2017/6/3.
 */
public class ThreadB extends Thread
{
    private DBTools dbTools;

    public ThreadB(DBTools dbTools) {
        this.dbTools = dbTools;
    }

    @Override
    public void run() {
        dbTools.backB();
    }
}
```

测试：

```java
package com.zhisheng.thread.thread6;

/**
 * Created by 10412 on 2017/6/3.
 */
public class Test
{
    public static void main(String[] args) {
        DBTools dbTools = new DBTools();
        for (int i = 0; i < 20; i++) {
            ThreadB tb = new ThreadB(dbTools);
            tb.start();
            ThreadA ta = new ThreadA(dbTools);
            ta.start();
        }
    }
}
```



### Join 方法的使用

作用：等待线程对象销毁

join 方法具有使线程排队运行的作用，有些类似同步的运行效果。join 与 synchronized 的区别是：join 在内部使用 wait() 方法进行等待，而 synchronized 关键字使用的是 “对象监视器” 原理做为同步。

在 join 过程中，如果当前线程对象被中断，则当前线程出现异常。

方法 join(long) 中的参数是设定等待的时间。

```java
/**
     * 等待该线程终止的时间最长为 millis 毫秒。超时为 0 意味着要一直等下去。
     * Waits at most {@code millis} milliseconds for this thread to
     * die. A timeout of {@code 0} means to wait forever.
     *
     * <p> This implementation uses a loop of {@code this.wait} calls
     * conditioned on {@code this.isAlive}. As a thread terminates the
     * {@code this.notifyAll} method is invoked. It is recommended that
     * applications not use {@code wait}, {@code notify}, or
     * {@code notifyAll} on {@code Thread} instances.
     *
     * @param  millis
     *         the time to wait in milliseconds
     *
     * @throws  IllegalArgumentException
     *          if the value of {@code millis} is negative
     *
     * @throws  InterruptedException
     *          if any thread has interrupted the current thread. The
     *          <i>interrupted status</i> of the current thread is
     *          cleared when this exception is thrown.
     */
    public final synchronized void join(long millis)
    throws InterruptedException {
        long base = System.currentTimeMillis();
        long now = 0;
        if (millis < 0) {
            throw new IllegalArgumentException("timeout value is negative");
        if (millis == 0) {
            while (isAlive()) {
                wait(0);
            }
        } else {
            while (isAlive()) {
                long delay = millis - now;
                if (delay <= 0) {
                    break;
                }
                wait(delay);
                now = System.currentTimeMillis() - base;
            }
        }
    }
```

### 类  ThreadLocal  的使用

该类提供了线程局部 (thread-local) 变量。这些变量不同于它们的普通对应物，因为访问某个变量（通过其 get 或
set 方法）的每个线程都有自己的局部变量，它独立于变量的初始化副本。ThreadLocal 实例通常是类中的
private static 字段，它们希望将状态与某一个线程（例如，用户 ID 或事务 ID）相关联。

#### get() 方法

```java
public T get() {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null) {
            ThreadLocalMap.Entry e = map.getEntry(this);
            if (e != null) {
                @SuppressWarnings("unchecked")
                T result = (T)e.value;
                return result;
            }
        }
        return setInitialValue();
    }
```

返回此线程局部变量的当前线程副本中的值。如果变量没有用于当前线程的值，则先将其初始化为调用 initialValue() 方法返回的值。

### InheritableThreadLocal 类的使用

该类扩展了 ThreadLocal，为子线程提供从父线程那里继承的值：在创建子线程时，子线程会接收所有可继承的线程局部变量的初始值，以获得父线程所具有的值。通常，子线程的值与父线程的值是一致的；但是，通过重写这个类中的 childValue 方法，子线程的值可以作为父线程值的一个任意函数。

当必须将变量（如用户 ID 和 事务 ID）中维护的每线程属性（per-thread-attribute）自动传送给创建的所有子线程时，应尽可能地采用可继承的线程局部变量，而不是采用普通的线程局部变量。



## 第四章 ——  Lock 的使用

### 使用 ReentrantLock 类

一个可重入的互斥锁 Lock，它具有与使用 `synchronized` 方法和语句所访问的隐式监视器锁相同的一些基本行为和语义，但功能更强大。

`ReentrantLock` 将由最近成功获得锁，并且还没有释放该锁的线程所*拥有*。当锁没有被另一个线程所拥有时，调用 `lock` 的线程将成功获取该锁并返回。如果当前线程已经拥有该锁，此方法将立即返回。可以使用 `isHeldByCurrentThread()`和 `getHoldCount()`方法来检查此情况是否发生。

此类的构造方法接受一个可选的*公平* 参数。当设置为 `true` 时，在多个线程的争用下，这些锁倾向于将访问权授予等待时间最长的线程。否则此锁将无法保证任何特定访问顺序。与采用默认设置（使用不公平锁）相比，使用公平锁的程序在许多线程访问时表现为很低的总体吞吐量（即速度很慢，常常极其慢），但是在获得锁和保证锁分配的均衡性时差异较小。不过要注意的是，公平锁不能保证线程调度的公平性。因此，使用公平锁的众多线程中的一员可能获得多倍的成功机会，这种情况发生在其他活动线程没有被处理并且目前并未持有锁时。还要注意的是，未定时的 `tryLock`方法并没有使用公平设置。因为即使其他线程正在等待，只要该锁是可用的，此方法就可以获得成功。

建议*总是* 立即实践，使用 `lock` 块来调用 `try`，在之前/之后的构造中，最典型的代码如下：

```java
class X {
   private final ReentrantLock lock = new ReentrantLock();
   // ...

   public void m() {
     lock.lock();  // block until condition holds
     try {
       // ... method body
     } finally {
       lock.unlock()
     }
   }
 }
```

### Condition

Condition 将 Object 监视器方法（wait、notify 和 notifyAll）分解成截然不同的对象，以便通过将这些对象与任意 Lock 实现组合使用，为每个对象提供多个等待 set（wait-set）。其中，Lock 替代了 synchronized 方法和语句的使用，Condition 替代了 Object 监视器方法的使用。

假定有一个绑定的缓冲区，它支持 put 和 take 方法。如果试图在空的缓冲区上执行 take 操作，则在某一个项变得可用之前，线程将一直阻塞；如果试图在满的缓冲区上执行 put 操作，则在有空间变得可用之前，线程将一直阻塞。我们喜欢在单独的等待 set 中保存 put 线程和 take 线程，这样就可以在缓冲区中的项或空间变得可用时利用最佳规划，一次只通知一个线程。可以使用两个 Condition 实例来做到这一点。

```java
class BoundedBuffer {
   final Lock lock = new ReentrantLock();
   final Condition notFull  = lock.newCondition();
   final Condition notEmpty = lock.newCondition();

   final Object[] items = new Object[100];
   int putptr, takeptr, count;

   public void put(Object x) throws InterruptedException {
     lock.lock();
     try {
       while (count == items.length)
         notFull.await();
       items[putptr] = x;
       if (++putptr == items.length) putptr = 0;
       ++count;
       notEmpty.signal();
     } finally {
       lock.unlock();
     }
   }

   public Object take() throws InterruptedException {
     lock.lock();
     try {
       while (count == 0)
         notEmpty.await();
       Object x = items[takeptr];
       if (++takeptr == items.length) takeptr = 0;
       --count;
       notFull.signal();
       return x;
     } finally {
       lock.unlock();
     }
   }
 }
```

### 正确使用 Condition 实现等待/通知

MyService.java

```java
package com.zhisheng.thread.Thread9;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by 10412 on 2017/6/4.
 */
public class MyService
{
    private Lock lock = new ReentrantLock();
    private Condition condition = lock.newCondition();

    public void await() {
        lock.lock();
        try {
            System.out.println("await A");
            condition.await();//使当前执行的线程处于等待状态 waiting
            System.out.println("await B");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }finally {
            lock.unlock();
            System.out.println("释放锁");
        }
    }

    public void signal() {
        lock.lock();
        System.out.println("signal A");
        condition.signal();
        System.out.println("signal B");
        lock.unlock();
    }
}
```

ThreadA.java

```java
package com.zhisheng.thread.Thread9;

/**
 * Created by 10412 on 2017/6/4.
 */
public class ThreadA extends Thread
{
    private MyService service;

    public ThreadA(MyService service) {
        this.service = service;
    }

    @Override
    public void run() {
        service.await();
    }
}
```

Test.java

```java
package com.zhisheng.thread.Thread9;

/**
 * Created by 10412 on 2017/6/4.
 */
public class Test
{
    public static void main(String[] args) throws InterruptedException {
        MyService service = new MyService();
        ThreadA ta = new ThreadA(service);
        ta.start();
        Thread.sleep(5000);
        service.signal();
    }
}
```

运行结果：

```java
await A
signal A
signal B
await B
释放锁
```

Object 类中的 wait() 方法相当于 Condition 类中 await() 方法

Object 类中的 wait(long time) 方法相当于 Condition 类中 await(long time, TimeUnit unit) 方法

Object 类中的 notify() 方法相当于 Condition 类中 signal() 方法

Object 类中的 notifyAll() 方法相当于 Condition 类中 signalAll() 方法



题目：实现生产者与消费者  一对一交替打印

MyService.java

```java
package com.zhisheng.thread.thread10;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by 10412 on 2017/6/4.
 * 实现生产者与消费者  一对一·交替打印
 */
public class MyService
{
    private Lock lock = new ReentrantLock();
    private Condition condition = lock.newCondition();
    private  boolean flag = false;

    public void setValue() {
        lock.lock();
        while (flag == true) {
            try {
                condition.await();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("SetValue  AAAAAA");
        flag = true;
        condition.signal();
        lock.unlock();
    }

    public void getValue() {
        lock.lock();
        while (flag == false) {
            try {
                condition.await();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("GetValue BBBB");
        flag = false;
        condition.signal();
        lock.unlock();
    }
}
```

ThreadA.java

```java
package com.zhisheng.thread.thread10;

/**
 * Created by 10412 on 2017/6/4.
 */
public class ThreadA extends Thread
{
    private MyService service;

    public ThreadA(MyService service) {
        this.service = service;
    }

    @Override
    public void run() {
        for (int i = 0; i < Integer.MAX_VALUE; i++) {
            service.setValue();
        }
    }
}
```

ThreadB.java

```java
package com.zhisheng.thread.thread10;

/**
 * Created by 10412 on 2017/6/4.
 */
public class ThreadB extends Thread
{
    private MyService service;

    public ThreadB(MyService service) {
        this.service = service;
    }

    @Override
    public void run() {
        for (int i = 0; i < Integer.MAX_VALUE; i++) {
            service.getValue();
        }
    }
}
```

Test.java

```java
package com.zhisheng.thread.thread10;

/**
 * Created by 10412 on 2017/6/4.
 */
public class Test
{
    public static void main(String[] args) {
        MyService service = new MyService();
        ThreadA ta = new ThreadA(service);
        ThreadB tb = new ThreadB(service);
        ta.start();
        tb.start();
    }
}
```



getHoldCount() 查询当前线程保持此锁定的个数，也就是调用 lock() 的方法

getQueueLength() 返回正等待获取此锁定的线程估计数

getWaitQueueLength() 返回等待与此锁定相关的给定条件 Condition 的线程估计数

hasQueuedThread() 查询指定的线程是否正在等待获取此锁定

hasQueuedThreads() 查询是否有线程正在等待获取此锁定

hasWaiters() 查询是否有线程正在等待与此锁定有关的 condition 条件

isFair() 判断是否是公平锁（默认下 ReentrantLock类使用的是非公平锁）

isHeldByCurrentThread() 查询当前线程是否保持此锁定

isLocked() 查询此锁定是否由任意线程保持

lockInterruptibly() 如果当前线程未被中断，则获取锁定，如果已经被中断则出现异常

tryLock() 仅在调用时锁定未被另一个线程保持的情况下，才获取该锁定

tryLock(long time, TimeUtil util) 如果锁定在给定的等待时间内没有被另一个线程保持，且当前线程未被中断，则获取该锁定。

### 使用 ReentrantReadWriteLock 类

读写互斥：

MyService.java

```java
package com.zhisheng.thread.Thread11;

import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * Created by 10412 on 2017/6/4.
 */
public class MyService
{
    private ReentrantReadWriteLock lock = new ReentrantReadWriteLock();

    public void read() {
        lock.readLock().lock();
        System.out.println(Thread.currentThread().getName() + " Read AAA  " + System.currentTimeMillis());
        try {
            Thread.sleep(10000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        lock.readLock().unlock();
    }

    public void write() {
        lock.writeLock().lock();
        System.out.println(Thread.currentThread().getName() + " write BBB " + System.currentTimeMillis());
        try {
            Thread.sleep(10000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        lock.writeLock().unlock();
    }
}
```

ThreadA.java

```java
package com.zhisheng.thread.Thread11;

/**
 * Created by 10412 on 2017/6/4.
 */
public class ThreadA extends Thread
{
    private MyService service;

    public ThreadA(MyService service) {
        this.service = service;
    }

    @Override
    public void run() {
        service.read();
    }
}
```

ThreadB.java

```java
package com.zhisheng.thread.Thread11;

/**
 * Created by 10412 on 2017/6/4.
 */
public class ThreadB extends Thread
{
    private MyService service;

    public ThreadB(MyService service) {
        this.service = service;
    }

    @Override
    public void run() {
        service.write();
    }
}
```

Test.java

```java
package com.zhisheng.thread.Thread11;

/**
 * Created by 10412 on 2017/6/4.
 */
public class Test
{
    public static void main(String[] args) throws InterruptedException {
        MyService service = new MyService();
        ThreadA ta = new ThreadA(service);
        ta.setName("A");
        ta.start();
        Thread.sleep(1000);
        ThreadB tb = new ThreadB(service);
        tb.setName("B");
        tb.start();
    }
}
```

运行结果：

```
A Read AAA  1496556770402
B write BBB 1496556780402
```





## 第六章 —— 单例模式与多线程

推荐文章 [《深入浅出单实例Singleton设计模式》](http://blog.csdn.net/tzs_1041218129/article/details/51246419)

### 立即加载模式 / “饿汉模式”

立即加载：使用类的时候已经将对象创建完毕，new 实例化

```java
public class MyObject
{
    private static MyObject object = new MyObject();
    private MyObject() {
    }
    public static MyObject getInstance() {
        return object;
    }
}
```

### 延迟加载 / “ 懒汉模式 ”

就是在调用 get 的时候实例才被创建。在 get() 方法中进行 new 实例化。

```java
public class MyObject
{
    private  static  MyObject object;
    private MyObject() {
    }
    public static MyObject getInstance() {
        if (object != null) {
        } else {
            object = new MyObject();
        }
        return object;
    }
}
```

使用 DCL 双重检查锁，解决“懒汉模式”遇到的多线程问题

```java
public class MyObject
{
    private  volatile static  MyObject object;
    private MyObject() {
    }
    //synchronized
    public static MyObject getInstance() {
        if (object != null) {
        } else {
            synchronized (MyObject.class) {
                if (object == null) {
                    object = new MyObject();
                }
            }
        }
        return object;
    }
}
```

### 使用静态内部类实现单例模式

```java
public class MyObject
{
    private static class MyObjectHandler
    {
        private static MyObject object = new MyObject();
    }
    private MyObject() {
    }
    public static MyObject getInstance() {
        return MyObjectHandler.object;
    }
}
```

### 序列化与反序列化的单例模式实现

MyObject.java

```java
package com.zhisheng.thread.thread15;

import java.io.ObjectStreamException;
import java.io.Serializable;

/**
 * Created by 10412 on 2017/6/4.
 */
public class MyObject implements Serializable
{
    private static final long serialVersionUID =  888L;
    private static class MyObjectHandler
    {
        private static final MyObject object = new MyObject();
    }
    private MyObject() {
    }
    public static  MyObject getInstance() {
        return MyObjectHandler.object;
    }
    protected Object readResolve() throws ObjectStreamException {
        System.out.println("调用了readResolve方法！");
        return MyObjectHandler.object;
    }
}
```

SaveAndRead.java

```java
package com.zhisheng.thread.thread15;

import java.io.*;

/**
 * Created by 10412 on 2017/6/4.
 */
public class SaveAndRead
{
    public static void main(String[] args) {
        try {
            MyObject object = MyObject.getInstance();
            FileOutputStream fos = new FileOutputStream(new File("fos.txt"));
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(object);
            oos.close();
            fos.close();
            System.out.println(object.hashCode());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        try {
            FileInputStream fis = new FileInputStream(new File("fos.txt"));
            ObjectInputStream ois = new ObjectInputStream(fis);
            MyObject o = (MyObject) ois.readObject();
            ois.close();
            fis.close();
            System.out.println(o.hashCode());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
```

这里主要要指出 MyObject.java 中 readResolve 方法

```java
 protected Object readResolve() throws ObjectStreamException {
        System.out.println("调用了readResolve方法！");
        return MyObjectHandler.object;
    }
```

方法 readResolve 允许 class 在反序列化返回对象前替换、解析在流中读出来的对象。实现 readResolve 方法，一个 class 可以直接控制反序化返回的类型和对象引用。

方法 readResolve 会在 ObjectInputStream 已经读取一个对象并在准备返回前调用。ObjectInputStream 会检查对象的 class 是否定义了 readResolve 方法。如果定义了，将由 readResolve 方法指定返回的对象。返回对象的类型一定要是兼容的，否则会抛出 ClassCastException 。

### 使用 static 代码块实现单例模式

```java
package com.zhisheng.thread.thread16;

/**
 * Created by 10412 on 2017/6/4.
 */
public class MyObject
{
    private static MyObject instance = null;
    private MyObject() {
    }
    static {
        instance = new MyObject();
    }
    public static MyObject getInstance() {
        return instance;
    }
}
```

ThreadA.java

```java
package com.zhisheng.thread.thread16;

/**
 * Created by 10412 on 2017/6/4.
 */
public class ThreadA extends Thread
{
    @Override
    public void run() {
        for (int i = 0; i < 5; i++) {
            System.out.println(MyObject.getInstance().hashCode());
        }
    }
}
```

Test.java

```java
package com.zhisheng.thread.thread16;

/**
 * Created by 10412 on 2017/6/4.
 */
public class Test
{
    public static void main(String[] args) {
        ThreadA ta1 = new ThreadA();
        ThreadA ta2 = new ThreadA();
        ThreadA ta3 = new ThreadA();
        ta1.start();
        ta2.start();
        ta3.start();
    }
}
```

### 使用枚举数据类型实现单例模式

在使用枚举类时，构造方法会被自动调用，也可以应用这个特性实现单例模式。

```java
public class MyObject {
    private enum MyEnumSingleton{
        INSTANCE;
        private Resource resource;
        private MyEnumSingleton(){
            resource = new Resource();
        }
        public Resource getResource(){
            return resource;
        }
    }
    public static Resource getResource(){
        return MyEnumSingleton.INSTANCE.getResource();
    }
}
```

测试：

```java
import test.MyObject;

public class Run {
    class MyThread extends Thread {
        @Override
        public void run() {
            for (int i = 0; i < 5; i++) {
                System.out.println(MyObject.getResource().hashCode());
            }
        }
    }
    public static void main(String[] args) {
        Run.MyThread t1 = new Run().new MyThread();
        Run.MyThread t2 = new Run().new MyThread();
        Run.MyThread t3 = new Run().new MyThread();
        t1.start();
        t2.start();
        t3.start();

    }
}
```

这里再推荐一篇 stackoverflow 上的一个问题回答： [What is an efficient way to implement a singleton pattern in Java?](https://stackoverflow.com/questions/70689/what-is-an-efficient-way-to-implement-a-singleton-pattern-in-java)



## 总结

本篇文章是我读 《Java多线程编程核心技术》 的笔记及自己的一些总结，觉得不错，欢迎点赞和转发。


', 1, 'post', 'publish', 'Java', 'Java', 8, 0, 1, 1, 1);
INSERT INTO blog.t_contents (cid, title, slug, created, modified, content, author_id, type, status, tags, categories, hits, comments_num, allow_comment, allow_ping, allow_feed) VALUES (4, 'HashMap、Hashtable、HashSet 和 ConcurrentHashMap 的比较', 'HashMap-HashTable', 1497323623, 1497323623, 'HashMap 和 Hashtable 的比较是 Java 面试中的常见问题，用来考验程序员是否能够正确使用集合类以及是否可以随机应变使用多种思路解决问题。HashMap 的工作原理、ArrayList 与 Vector 的比较以及这个问题是有关 Java 集合框架的最经典的问题。Hashtable 是个过时的集合类，存在于 Java API 中很久了。在 Java 4 中被重写了，实现了 Map 接口，所以自此以后也成了 Java 集合框架中的一部分。Hashtable 和 HashMap 在 Java 面试中相当容易被问到，甚至成为了集合框架面试题中最常被考的问题，所以在参加任何 Java 面试之前，都不要忘了准备这一题。
<!-- more -->
这篇文章中，我们不仅将会看到 HashMap 和 Hashtable 的区别，还将看到它们之间的相似之处。

### HashMap 和 Hashtable 的区别

HashMap 和 Hashtable 都实现了 Map 接口，但决定用哪一个之前先要弄清楚它们之间的分别。主要的区别有：线程安全性，同步 (synchronization)，以及速度。

1. HashMap 几乎可以等价于 Hashtable，除了 HashMap 是非 synchronized 的，并可以接受 null(HashMap 可以接受为 null 的键值 (key) 和值 (value)，而 Hashtable 则不行)。
2. HashMap 是非 synchronized，而 Hashtable 是 synchronized，这意味着 Hashtable 是线程安全的，多个线程可以共享一个 Hashtable；而如果没有正确的同步的话，多个线程是不能共享 HashMap 的。Java 5 提供了 ConcurrentHashMap，它是 HashTable 的替代，比 HashTable 的扩展性更好。
3. 另一个区别是 HashMap 的迭代器 (Iterator) 是 fail-fast 迭代器，而 Hashtable 的 enumerator 迭代器不是 fail-fast 的。所以当有其它线程改变了 HashMap 的结构（增加或者移除元素），将会抛出ConcurrentModificationException，但迭代器本身的 remove() 方法移除元素则不会抛出ConcurrentModificationException 异常。但这并不是一个一定发生的行为，要看 JVM。这条同样也是Enumeration 和 Iterato r的区别。
4. 由于 Hashtable 是线程安全的也是 synchronized，所以在单线程环境下它比 HashMap 要慢。如果你不需要同步，只需要单一线程，那么使用 HashMap 性能要好过 Hashtable。
5. HashMap 不能保证随着时间的推移 Map 中的元素次序是不变的。

### 要注意的一些重要术语：

1) sychronized 意味着在一次仅有一个线程能够更改 Hashtable。就是说任何线程要更新 Hashtable 时要首先获得同步锁，其它线程要等到同步锁被释放之后才能再次获得同步锁更新 Hashtable。

2) Fail-safe 和 iterator 迭代器相关。如果某个集合对象创建了 Iterator 或者 ListIterator，然后其它的线程试图“结构上”更改集合对象，将会抛出 ConcurrentModificationException 异常。但其它线程可以通过 set() 方法更改集合对象是允许的，因为这并没有从“结构上”更改集合。但是假如已经从结构上进行了更改，再调用 set() 方法，将会抛出 IllegalArgumentException 异常。

3) 结构上的更改指的是删除或者插入一个元素，这样会影响到 map 的结构。

### 我们能否让 HashMap 同步？

HashMap 可以通过下面的语句进行同步：
Map m = Collections.synchronizeMap(hashMap);

### 结论

Hashtable 和 HashMap 有几个主要的不同：线程安全以及速度。仅在你需要完全的线程安全的时候使用Hashtable，而如果你使用 Java 5 或以上的话，请使用 ConcurrentHashMap 吧。

转载自：[HashMap和Hashtable的区别](http://www.importnew.com/7010.html)

***

关于 HashMap 线程不安全这一点，《Java并发编程的艺术》一书中是这样说的：

> HashMap 在并发执行 put 操作时会引起死循环，导致 CPU 利用率接近 100%。因为多线程会导致 HashMap 的 Node 链表形成环形数据结构，一旦形成环形数据结构，Node 的 next 节点永远不为空，就会在获取 Node 时产生死循环。

原因：

+ [疫苗：JAVA HASHMAP的死循环 —— 酷壳](http://coolshell.cn/articles/9606.html)
+ [HashMap在java并发中如何发生死循环](http://firezhfox.iteye.com/blog/2241043)
+ [How does a HashMap work in JAVA](http://coding-geek.com/how-does-a-hashmap-work-in-java/)

***

下面的是自己有道云笔记中记录的：

**HashMap ， HashTable 和 HashSet 区别**

1.  关于 HashMap 的一些说法：

a)  HashMap 实际上是一个“链表散列”的数据结构，即数组和链表的结合体。HashMap 的底层结构是一个数组，数组中的每一项是一条链表。

b)  HashMap 的实例有俩个参数影响其性能： “初始容量” 和 装填因子。

c)  HashMap 实现不同步，线程不安全。  HashTable 线程安全

d)  HashMap 中的 key-value 都是存储在 Entry 中的。

e)  HashMap 可以存 null 键和 null 值，不保证元素的顺序恒久不变，它的底层使用的是数组和链表，通过hashCode() 方法和 equals 方法保证键的唯一性

f)  解决冲突主要有三种方法：定址法，拉链法，再散列法。HashMap 是采用拉链法解决哈希冲突的。

注： 链表法是将相同 hash 值的对象组成一个链表放在 hash 值对应的槽位；

用开放定址法解决冲突的做法是：当冲突发生时，使用某种探查(亦称探测)技术在散列表中形成一个探查(测)序列。 沿此序列逐个单元地查找，直到找到给定 的关键字，或者碰到一个开放的地址(即该地址单元为空)为止（若要插入，在探查到开放的地址，则可将待插入的新结点存人该地址单元）。

拉链法解决冲突的做法是： 将所有关键字为同义词的结点链接在同一个单链表中 。若选定的散列表长度为m，则可将散列表定义为一个由m个头指针组成的指针数 组T[0..m-1]。凡是散列地址为i的结点，均插入到以T[i]为头指针的单链表中。T中各分量的初值均应为空指针。在拉链法中，装填因子α可以大于1，但一般均取α≤1。拉链法适合未规定元素的大小。

   

2.  Hashtable 和 HashMap 的区别：

a)   继承不同。

 public class Hashtable extends Dictionary implements Map

public class HashMap extends  AbstractMap implements Map

b)  Hashtable 中的方法是同步的，而 HashMap 中的方法在缺省情况下是非同步的。在多线程并发的环境下，可以直接使用 Hashtable，但是要使用 HashMap 的话就要自己增加同步处理了。

c)  Hashtable 中， key 和 value 都不允许出现 null 值。 在 HashMap 中， null 可以作为键，这样的键只有一个；可以有一个或多个键所对应的值为 null 。当 get() 方法返回 null 值时，即可以表示 HashMap 中没有该键，也可以表示该键所对应的值为 null 。因此，在 HashMap 中不能由 get() 方法来判断 HashMap 中是否存在某个键， 而应该用 containsKey() 方法来判断。

d)  两个遍历方式的内部实现上不同。Hashtable、HashMap 都使用了Iterator。而由于历史原因，Hashtable还使用了 Enumeration 的方式 。

e)  哈希值的使用不同，HashTable 直接使用对象的 hashCode。而 HashMap 重新计算 hash 值。

f)  Hashtable 和 HashMap 它们两个内部实现方式的数组的初始大小和扩容的方式。HashTable 中 hash 数组默认大小是11，增加的方式是 old*2+1。HashMap 中 hash 数组的默认大小是 16，而且一定是2的指数。

注：  HashSet 子类依靠 hashCode() 和 equal() 方法来区分重复元素。

HashSet 内部使用 Map 保存数据，即将 HashSet 的数据作为 Map 的 key 值保存，这也是 HashSet 中元素不能重复的原因。而 Map 中保存 key 值的,会去判断当前 Map 中是否含有该 Key 对象，内部是先通过 key 的hashCode, 确定有相同的 hashCode 之后，再通过 equals 方法判断是否相同。

***

《HashMap 的工作原理》

HashMap的工作原理是近年来常见的Java面试题。几乎每个Java程序员都知道HashMap，都知道哪里要用HashMap，知道 Hashtable和HashMap之间的区别，那么为何这道面试题如此特殊呢？是因为这道题考察的深度很深。这题经常出现在高级或中高级面试中。投资银行更喜欢问这个问题，甚至会要求你实现HashMap来考察你的编程能力。ConcurrentHashMap和其它同步集合的引入让这道题变得更加复杂。让我们开始探索的旅程吧！

### 先来些简单的问题

**“你用过HashMap吗？” “什么是HashMap？你为什么用到它？”**

几乎每个人都会回答“是的”，然后回答HashMap的一些特性，譬如HashMap可以接受null键值和值，而Hashtable则不能；HashMap是非synchronized;HashMap很快；以及HashMap储存的是键值对等等。这显示出你已经用过HashMap，而且对它相当的熟悉。但是面试官来个急转直下，从此刻开始问出一些刁钻的问题，关于HashMap的更多基础的细节。面试官可能会问出下面的问题：

**“你知道HashMap的工作原理吗？” “你知道HashMap的get()方法的工作原理吗？”**

你也许会回答“我没有详查标准的Java API，你可以看看Java源代码或者Open JDK。”“我可以用Google找到答案。”

但一些面试者可能可以给出答案，“HashMap是基于hashing的原理，我们使用put(key, value)存储对象到HashMap中，使用get(key)从HashMap中获取对象。当我们给put()方法传递键和值时，我们先对键调用hashCode()方法，返回的hashCode用于找到bucket位置来储存Entry对象。”这里关键点在于指出，HashMap是在bucket中储存键对象和值对象，作为Map.Entry。这一点有助于理解获取对象的逻辑。如果你没有意识到这一点，或者错误的认为仅仅只在bucket中存储值的话，你将不会回答如何从HashMap中获取对象的逻辑。这个答案相当的正确，也显示出面试者确实知道hashing以及HashMap的工作原理。但是这仅仅是故事的开始，当面试官加入一些Java程序员每天要碰到的实际场景的时候，错误的答案频现。下个问题可能是关于HashMap中的碰撞探测(collision detection)以及碰撞的解决方法：

**“当两个对象的hashcode相同会发生什么？”** 

从这里开始，真正的困惑开始了，一些面试者会回答因为hashcode相同，所以两个对象是相等的，HashMap将会抛出异常，或者不会存储它们。然后面试官可能会提醒他们有equals()和hashCode()两个方法，并告诉他们两个对象就算hashcode相同，但是它们可能并不相等。一些面试者可能就此放弃，而另外一些还能继续挺进，他们回答“因为hashcode相同，所以它们的bucket位置相同，‘碰撞’会发生。因为HashMap使用链表存储对象，这个Entry(包含有键值对的Map.Entry对象)会存储在链表中。”这个答案非常的合理，虽然有很多种处理碰撞的方法，这种方法是最简单的，也正是HashMap的处理方法。但故事还没有完结，面试官会继续问：

**“如果两个键的hashcode相同，你如何获取值对象？”**

 面试者会回答：当我们调用get()方法，HashMap会使用键对象的hashcode找到bucket位置，然后获取值对象。面试官提醒他如果有两个值对象储存在同一个bucket，他给出答案:将会遍历链表直到找到值对象。面试官会问因为你并没有值对象去比较，你是如何确定确定找到值对象的？除非面试者直到HashMap在链表中存储的是键值对，否则他们不可能回答出这一题。

其中一些记得这个重要知识点的面试者会说，找到bucket位置之后，会调用keys.equals()方法去找到链表中正确的节点，最终找到要找的值对象。完美的答案！

许多情况下，面试者会在这个环节中出错，因为他们混淆了hashCode()和equals()方法。因为在此之前hashCode()屡屡出现，而equals()方法仅仅在获取值对象的时候才出现。一些优秀的开发者会指出使用不可变的、声明作final的对象，并且采用合适的equals()和hashCode()方法的话，将会减少碰撞的发生，提高效率。不可变性使得能够缓存不同键的hashcode，这将提高整个获取对象的速度，使用String，Interger这样的wrapper类作为键是非常好的选择。

如果你认为到这里已经完结了，那么听到下面这个问题的时候，你会大吃一惊。

**“如果HashMap的大小超过了负载因子(load factor)定义的容量，怎么办？”**

除非你真正知道HashMap的工作原理，否则你将回答不出这道题。默认的负载因子大小为0.75，也就是说，当一个map填满了75%的bucket时候，和其它集合类(如ArrayList等)一样，将会创建原来HashMap大小的两倍的bucket数组，来重新调整map的大小，并将原来的对象放入新的bucket数组中。这个过程叫作rehashing，因为它调用hash方法找到新的bucket位置。

如果你能够回答这道问题，下面的问题来了：

**“你了解重新调整HashMap大小存在什么问题吗？”**

你可能回答不上来，这时面试官会提醒你当多线程的情况下，可能产生条件竞争(race condition)。

当重新调整HashMap大小的时候，确实存在条件竞争，因为如果两个线程都发现HashMap需要重新调整大小了，它们会同时试着调整大小。在调整大小的过程中，存储在链表中的元素的次序会反过来，因为移动到新的bucket位置的时候，HashMap并不会将元素放在链表的尾部，而是放在头部，这是为了避免尾部遍历(tail traversing)。如果条件竞争发生了，那么就死循环了。这个时候，你可以质问面试官，为什么这么奇怪，要在多线程的环境下使用HashMap呢？：）

热心的读者贡献了更多的关于HashMap的问题：

1. **为什么String, Interger这样的wrapper类适合作为键？** 

   String, Interger这样的wrapper类作为HashMap的键是再适合不过了，而且String最为常用。因为String是不可变的，也是final的，而且已经重写了equals()和hashCode()方法了。其他的wrapper类也有这个特点。不可变性是必要的，因为为了要计算hashCode()，就要防止键值改变，如果键值在放入时和获取时返回不同的hashcode的话，那么就不能从HashMap中找到你想要的对象。不可变性还有其他的优点如线程安全。如果你可以仅仅通过将某个field声明成final就能保证hashCode是不变的，那么请这么做吧。因为获取对象的时候要用到equals()和hashCode()方法，那么键对象正确的重写这两个方法是非常重要的。如果两个不相等的对象返回不同的hashcode的话，那么碰撞的几率就会小些，这样就能提高HashMap的性能。

2. **我们可以使用自定义的对象作为键吗？** 

   这是前一个问题的延伸。当然你可能使用任何对象作为键，只要它遵守了equals()和hashCode()方法的定义规则，并且当对象插入到Map中之后将不会再改变了。如果这个自定义对象时不可变的，那么它已经满足了作为键的条件，因为当它创建之后就已经不能改变了。

3. **我们可以使用CocurrentHashMap来代替Hashtable吗？**

   这是另外一个很热门的面试题，因为ConcurrentHashMap越来越多人用了。我们知道Hashtable是synchronized的，但是ConcurrentHashMap同步性能更好，因为它仅仅根据同步级别对map的一部分进行上锁。ConcurrentHashMap当然可以代替HashTable，但是HashTable提供更强的线程安全性。看看 [这篇博客](http://javarevisited.blogspot.sg/2011/04/difference-between-concurrenthashmap.html) 查看Hashtable和ConcurrentHashMap的区别。

我个人很喜欢这个问题，因为这个问题的深度和广度，也不直接的涉及到不同的概念。让我们再来看看这些问题设计哪些知识点：

- hashing的概念
- HashMap中解决碰撞的方法
- equals()和hashCode()的应用，以及它们在HashMap中的重要性
- 不可变对象的好处
- HashMap多线程的条件竞争
- 重新调整HashMap的大小

### 总结

#### HashMap的工作原理

HashMap基于hashing原理，我们通过put()和get()方法储存和获取对象。当我们将键值对传递给put()方法时，它调用键对象的hashCode()方法来计算hashcode，让后找到bucket位置来储存值对象。当获取对象时，通过键对象的equals()方法找到正确的键值对，然后返回值对象。HashMap使用链表来解决碰撞问题，当发生碰撞了，对象将会储存在链表的下一个节点中。 HashMap在每个链表节点中储存键值对对象。

当两个不同的键对象的hashcode相同时会发生什么？ 它们会储存在同一个bucket位置的链表中。键对象的equals()方法用来找到键值对。

因为HashMap的好处非常多，我曾经在电子商务的应用中使用HashMap作为缓存。因为金融领域非常多的运用Java，也出于性能的考虑，我们会经常用到HashMap和ConcurrentHashMap。你可以查看更多的关于HashMap的文章:

- [HashMap和Hashtable的区别](http://www.importnew.com/7010.html)
- [HashMap和HashSet的区别](http://www.importnew.com/6931.html)

转载自：[HashMap的工作原理](http://www.importnew.com/7099.html)

***

其他的 HashMap 学习资料：

+ [jdk7中HashMap知识点整理](https://segmentfault.com/a/1190000003617333)
+ [HashMap源码分析（四）put-jdk8-红黑树的引入](http://blog.csdn.net/q291611265/article/details/46797557)
+ [JDK7与JDK8中HashMap的实现](https://my.oschina.net/hosee/blog/618953)
+ [JDK1.8HashMap原理和源码分析(java面试收藏)](https://wenku.baidu.com/view/6e1035943968011ca30091cd.html)
+ [谈谈ConcurrentHashMap1.7和1.8的不同实现](http://www.jianshu.com/p/e694f1e868ec)
+ [jdk1.8的HashMap和ConcurrentHashMap](https://my.oschina.net/pingpangkuangmo/blog/817973)
+ [ConcurrentHashMap源码分析（JDK8版本）](http://blog.csdn.net/u010723709/article/details/48007881)

***

### 最后

谢谢阅读，如果可以的话欢迎大家转发和点赞。如需转载注明[原地址](www.54tianzhisheng.cn/2017/06/10/HashMap-Hashtable/)就行。

群 528776268 欢迎各位大牛进群一起讨论。

![](http://ohfk1r827.bkt.clouddn.com/1473414112000.png)', 1, 'post', 'publish', 'Java,HashMap,HashTable,HashSet,ConcurrentHashMap', 'Java', 2, 0, 1, 1, 1);
INSERT INTO blog.t_contents (cid, title, slug, created, modified, content, author_id, type, status, tags, categories, hits, comments_num, allow_comment, allow_ping, allow_feed) VALUES (5, 'Pyspider框架 —— Python爬虫实战之爬取 V2EX 网站帖子', 'Pyspider-v2ex', 1497323771, 1497323835, '**背景：**

**PySpider**：一个国人编写的强大的网络爬虫系统并带有强大的WebUI。采用Python语言编写，分布式架构，支持多种数据库后端，强大的WebUI支持脚本编辑器，任务监视器，项目管理器以及结果查看器。在线示例： **http://demo.pyspider.org/**

**官方文档： http://docs.pyspider.org/en/latest/** 

**Github :  https://github.com/binux/pyspider** 

本文爬虫代码 Github 地址：**https://github.com/zhisheng17/Python-Projects/blob/master/v2ex/V2EX.py**

<!-- more -->

***

说了这么多，我们还是来看正文吧！

**前提:** 你已经安装好了Pyspider 和 MySQL-python（保存数据）

如果你还没安装的话，请看看我的前一篇文章，防止你也走弯路。

1. [**Pyspider 框架学习时走过的一些坑**](http://blog.csdn.net/tzs_1041218129/article/details/52877949)

2. [**HTTP 599: SSL certificate problem: unable to get local issuer certificate错误**](http://blog.csdn.net/tzs_1041218129/article/details/52853465)

我所遇到的一些错误：

![这里写图片描述](http://img.blog.csdn.net/20161022201123063)


首先，**本爬虫目标**：使用 Pyspider 框架爬取 [V2EX](www.v2ex.com) 网站的帖子中的问题和内容，然后将爬取的数据保存在本地。

V2EX 中大部分的帖子查看是不需要登录的，当然也有些帖子是需要登陆后才能够查看的。（因为后来爬取的时候发现一直 error ，查看具体原因后才知道是需要登录的才可以查看那些帖子的）所以我觉得没必要用到 Cookie，当然如果你非得要登录，那也很简单，简单地方法就是添加你登录后的 cookie 了。

我们在 https://www.v2ex.com/ 扫了一遍，发现并没有一个列表能包含所有的帖子，只能退而求其次，通过抓取分类下的所有的标签列表页，来遍历所有的帖子： https://www.v2ex.com/?tab=tech 然后是 https://www.v2ex.com/go/programmer  最后每个帖子的详情地址是 （举例）： https://www.v2ex.com/t/314683#reply1



**创建一个项目**

在 pyspider 的 dashboard 的右下角，点击 “Create” 按钮

![这里写图片描述](http://img.blog.csdn.net/20161022193415047)

替换 on_start 函数的 self.crawl 的 URL：

```
@every(minutes=24 * 60)
    def on_start(self):
        self.crawl(''https://www.v2ex.com/'', callback=self.index_page, validate_cert=False)
```

> + self.crawl 告诉 pyspider 抓取指定页面，然后使用 callback 函数对结果进行解析。
> + @every) 修饰器，表示 on_start 每天会执行一次，这样就能抓到最新的帖子了。
> + validate_cert=False 一定要这样，否则会报 HTTP 599: SSL certificate problem: unable to get local issuer certificate错误

**首页：**

点击绿色的 run 执行，你会看到 follows 上面有一个红色的 1，切换到 follows 面板，点击绿色的播放按钮：

![这里写图片描述](http://img.blog.csdn.net/20161022194343052)

![这里写图片描述](http://img.blog.csdn.net/20161022194412365)

第二张截图一开始是出现这个问题了，解决办法看前面写的文章，后来问题就不再会出现了。

<br>
**Tab 列表页 : **

![这里写图片描述](http://img.blog.csdn.net/20161022194637692)

在 tab 列表页 中，我们需要提取出所有的主题列表页 的 URL。你可能已经发现了，sample handler 已经提取了非常多大的 URL

代码：
```
@config(age=10 * 24 * 60 * 60)
    def index_page(self, response):
        for each in response.doc(''a[href^="https://www.v2ex.com/?tab="]'').items():
            self.crawl(each.attr.href, callback=self.tab_page, validate_cert=False)
```

> + 由于帖子列表页和 tab列表页长的并不一样，在这里新建了一个 callback 为 self.tab_page
> + @config(age=10 * 24 * 60 * 60) 在这表示我们认为 10 天内页面有效，不会再次进行更新抓取


**Go列表页 : **

![这里写图片描述](http://img.blog.csdn.net/20161022195235290)

代码：

```
@config(age=10 * 24 * 60 * 60)
    def tab_page(self, response):
        for each in response.doc(''a[href^="https://www.v2ex.com/go/"]'').items():
            self.crawl(each.attr.href, callback=self.board_page, validate_cert=False)
```

**帖子详情页（T）:**

![这里写图片描述](http://img.blog.csdn.net/20161022200023793)

你可以看到结果里面出现了一些reply的东西，对于这些我们是可以不需要的，我们可以去掉。

同时我们还需要让他自己实现自动翻页功能。

代码：
```
@config(age=10 * 24 * 60 * 60)
    def board_page(self, response):
        for each in response.doc(''a[href^="https://www.v2ex.com/t/"]'').items():
            url = each.attr.href
            if url.find(''#reply'')>0:
                url = url[0:url.find(''#'')]
            self.crawl(url, callback=self.detail_page, validate_cert=False)
        for each in response.doc(''a.page_normal'').items():
            self.crawl(each.attr.href, callback=self.board_page, validate_cert=False) #实现自动翻页功能
```

去掉后的运行截图：

![这里写图片描述](http://img.blog.csdn.net/20161022200324719)

实现自动翻页后的截图：

![这里写图片描述](http://img.blog.csdn.net/20161022201355970)

此时我们已经可以匹配了所有的帖子的 url 了。

点击每个帖子后面的按钮就可以查看帖子具体详情了。

![这里写图片描述](http://img.blog.csdn.net/20161022200539973)

代码：

```
@config(priority=2)
    def detail_page(self, response):
        title = response.doc(''h1'').text()
        content = response.doc(''div.topic_content'').html().replace(''"'', ''\\\\"'')
        self.add_question(title, content)  #插入数据库
        return {
            "url": response.url,
            "title": title,
            "content": content,
        }
```

插入数据库的话，需要我们在之前定义一个add_question函数。

```
#连接数据库
def __init__(self):
        self.db = MySQLdb.connect(''localhost'', ''root'', ''root'', ''wenda'', charset=''utf8'')

    def add_question(self, title, content):
        try:
            cursor = self.db.cursor()
            sql = ''insert into question(title, content, user_id, created_date, comment_count) values ("%s","%s",%d, %s, 0)'' % (title, content, random.randint(1, 10) , ''now()'');   #插入数据库的SQL语句
            print sql
            cursor.execute(sql)
            print cursor.lastrowid
            self.db.commit()
        except Exception, e:
            print e
            self.db.rollback()
```

查看爬虫运行结果：

![这里写图片描述](http://img.blog.csdn.net/20161022201700801)

> 1. 先debug下，再调成running。pyspider框架在windows下的bug
> 2. 设置跑的速度，建议不要跑的太快，否则很容易被发现是爬虫的，人家就会把你的IP给封掉的
> 3. 查看运行工作
> 4. 查看爬取下来的内容

![这里写图片描述](http://img.blog.csdn.net/20161022202033227)

![这里写图片描述](http://img.blog.csdn.net/20161022202048258)

然后再本地数据库GUI软件上查询下就可以看到数据已经保存到本地了。

自己需要用的话就可以导入出来了。

在开头我就告诉大家爬虫的代码了，如果详细的看看那个project，你就会找到我上传的爬取数据了。（仅供学习使用，切勿商用！）

当然你还会看到其他的爬虫代码的了，如果你觉得不错可以给个 Star，或者你也感兴趣的话，你可以fork我的项目，和我一起学习，这个项目长期更新下去。

**最后：**

代码：

```
# created by 10412
# !/usr/bin/env python
# -*- encoding: utf-8 -*-
# Created on 2016-10-20 20:43:00
# Project: V2EX

from pyspider.libs.base_handler import *

import re
import random
import MySQLdb

class Handler(BaseHandler):
    crawl_config = {
    }

    def __init__(self):
        self.db = MySQLdb.connect(''localhost'', ''root'', ''root'', ''wenda'', charset=''utf8'')

    def add_question(self, title, content):
        try:
            cursor = self.db.cursor()
            sql = ''insert into question(title, content, user_id, created_date, comment_count) values ("%s","%s",%d, %s, 0)'' % (title, content, random.randint(1, 10) , ''now()'');
            print sql
            cursor.execute(sql)
            print cursor.lastrowid
            self.db.commit()
        except Exception, e:
            print e
            self.db.rollback()


    @every(minutes=24 * 60)
    def on_start(self):
        self.crawl(''https://www.v2ex.com/'', callback=self.index_page, validate_cert=False)

    @config(age=10 * 24 * 60 * 60)
    def index_page(self, response):
        for each in response.doc(''a[href^="https://www.v2ex.com/?tab="]'').items():
            self.crawl(each.attr.href, callback=self.tab_page, validate_cert=False)


    @config(age=10 * 24 * 60 * 60)
    def tab_page(self, response):
        for each in response.doc(''a[href^="https://www.v2ex.com/go/"]'').items():
            self.crawl(each.attr.href, callback=self.board_page, validate_cert=False)


    @config(age=10 * 24 * 60 * 60)
    def board_page(self, response):
        for each in response.doc(''a[href^="https://www.v2ex.com/t/"]'').items():
            url = each.attr.href
            if url.find(''#reply'')>0:
                url = url[0:url.find(''#'')]
            self.crawl(url, callback=self.detail_page, validate_cert=False)
        for each in response.doc(''a.page_normal'').items():
            self.crawl(each.attr.href, callback=self.board_page, validate_cert=False)


    @config(priority=2)
    def detail_page(self, response):
        title = response.doc(''h1'').text()
        content = response.doc(''div.topic_content'').html().replace(''"'', ''\\\\"'')
        self.add_question(title, content)  #插入数据库
        return {
            "url": response.url,
            "title": title,
            "content": content,
        }



```', 1, 'post', 'publish', 'Pyspider,Python,爬虫', 'Python', 29, 0, 1, 1, 1);
INSERT INTO blog.t_contents (cid, title, slug, created, modified, content, author_id, type, status, tags, categories, hits, comments_num, allow_comment, allow_ping, allow_feed) VALUES (6, '《疯狂 Java 突破程序员基本功的 16 课》 读书笔记', 'Java-16-lession', 1497325618, 1497325636, '## 第 1 课 —— 数组与内存控制

### 数组初始化

数组初始化之后，该数组的长度是不可变的（可通过数组的 length 属性访问数组的长度）。Java 中的数组必须经过初始化（为数组对象的元素分配内存空间，并为每个数组元素指定初始值）才可使用。

数组初始化的形式：

+ 静态初始化：初始化时由程序员显示的指定每个数组的初始值，系统决定数组长度。
+ 动态初始化：初始化时程序员只指定数组的长度，系统为数组元素分配初始值。

<!-- more -->
### 使用数组

数组元素就是变量：例如 int[] 数组元素相当于 int 类型的变量

当通过索引来使用数组元素时（访问数组元素的值、为数组元素赋值），将该数组元素当成普通变量使用即可。



## 第 2 课 —— 对象与内存的控制

Java 内存管理分为：内存分配和内存回收。

> + 内存分配：创建 Java 对象时 JVM 为该对象在堆内存中所分配的内存空间。
> + 内存回收：当 Java 对象失去引用，变成垃圾，JVM 的垃圾回收机制自动清理该对象，并回收内存

### 实例变量 和 类变量

#### 局部变量

特点：作用时间短，存储在方法的栈内存中

种类：

+ 形参：方法签名中定义的局部变量，由方法调用者负责为其赋值，随方法结束而消亡
+ 方法内的局部变量：方法内定义的局部变量，必须在方法内对其进行显示初始化，从初始化后开始生效，随方法结束而消亡
+ 代码块内的局部变量：在代码块中定义的局部变量，必须在代码块中进行显示初始化，从初始化后开始生效，随代码块结束而消亡

#### 成员变量

类体内定义的变量，如果该成员变量没有使用 static 修饰，那该成员变量又被称为非静态变量或实例变量，如果使用 static 修饰，则该成员变量又可被称为静态变量或类变量。

#### 实例变量和类变量的属性

使用 static 修饰的成员变量是类变量，属于该类本身，没有使用 static 修饰的成员变量是实例变量，属于该类的实例，在同一个类中，每一个类只对应一个 Class 对象，但每个类可以创建多个对象。

由于同一个 JVM 内的每个类只对应一个 CLass 对象，因此同一个 JVM 内的一个类的类变量只需要一块内存空间；但对于实例变量而言，该类每创建一次实例，就需要为该实例变量分配一块内存空间。也就是说，程序中创建了几个实例，实例变量就需要几块内存空间。

这里我想到一道面试题目：

```java
public class A{
  {
    System.out.println("我是代码块");
  }
  static{
    System.out.println("我是静态代码块");
  }
  public static void main(String[] args) {
        A a = new A();
        A a1 = new A();
    }
}
```

结果：

```
我是静态代码块
我是代码块
我是代码块
```

静态代码块只执行一次，而代码块每创建一个实例，就会打印一次。

#### 实例变量的初始化时机

程序可在3个地方对实例变量执行初始化：

+ 定义实例变量时指定初始值
+ 非静态初始化块中对实例变量指定初始值
+ 构造器中对实例变量指定初始值

上面第一种和第二种方式比第三种方式更早执行，但第一、二种方式的执行顺序与他们在源程序中的排列顺序相同。

同样在上面那个代码上加上一个变量 weight 的成员变量，我们来验证下上面的初始化顺序：

1、`定义实例变量指定初始值` 在 `非静态初始化块对实例变量指定初始值` 之后:

```java
public class A{
    {
        weight = 2.1;
        System.out.println("我是代码块");
    }
    double weight = 2.0;
    static{
        System.out.println("我是静态代码块");
    }
    public static void main(String[] args) {
        A a = new A();
        A a1 = new A();
        System.out.println(a.weight);
    }
}
```

结果是：

```
我是静态代码块
我是代码块
我是代码块
2.0
```

2、`定义实例变量指定初始值` 在 `非静态初始化块对实例变量指定初始值` 之前:

```java
public class A{
	double weight = 2.0;
    {
        weight = 2.1;
        System.out.println("我是代码块");
    }
    static{
        System.out.println("我是静态代码块");
    }
    public static void main(String[] args) {
        A a = new A();
        A a1 = new A();
        System.out.println(a.weight);
    }
}
```

结果为：

```
我是静态代码块
我是代码块
我是代码块
2.1
```

大家有没有觉得很奇怪？

我来好好说清楚下：

> 定义实例变量时指定的初始值、初始代码块中为实例变量指定初始值的语句的地位是平等的，当经过编译器处理后，他们都将会被提取到构造器中。也就是说，这条语句 `double weight = 2.0;` 实际上会被分成如下 2 次执行：
>
> + `double weight;` : 创建 Java 对象时系统根据该语句为该对象分配内存。
> + `weight = 2.1;` : 这条语句将会被提取到 Java 类的构造器中执行。

只说原理，大家肯定不怎么信，那么还有拿出源码来，这样才有信服能力的吗？是不？

这里我直接使用软件将代码的字节码文件反编译过来，看看里面是怎样的组成？

第一个代码的反编译源码如下：

```java
public class A
{
  double weight;
  public A()
  {
    this.weight = 2.1D;
    System.out.println("我是代码块");
    this.weight = 2.0D;
  }
  static
  {
    System.out.println("我是静态代码块");
  }
  public static void main(String[] args)
  {
    A a = new A();
    A a1 = new A();
    System.out.println(a.weight);
  }
}
```

第二个代码反编译源码如下：

```java
public class A
{
  double weight;
  public A()
  {
    this.weight = 2.0D;
    this.weight = 2.1D;
    System.out.println("我是代码块");
  }
  static
  {
    System.out.println("我是静态代码块");
  }
  public static void main(String[] args)
  {
    A a = new A();
    A a1 = new A();
    System.out.println(a.weight);
  }
}
```

这下子满意了吧！

通过反编译的源码可以看到该类定义的 weight 实例变量时不再有初始值，为 weight 指定初始值的代码也被提到了构造器中去了，但是我们也可以发现之前规则也是满足的。

他们的赋值语句都被合并到构造器中，在合并过程中，定义的变量语句转换得到的赋值语句，初始代码块中的语句都转换得到的赋值语句，总是位于构造器的所有语句之前，合并后，两种赋值语句的顺序也保持了它们在 Java 源代码中的顺序。

大致过程应该了解了吧？如果还不怎么清楚的，建议还是自己将怎个过程在自己的电脑上操作一遍，毕竟光看不练假把式。

#### 类变量的初始化时机

JVM 对每一个 Java 类只初始化一次，因此 Java 程序每运行一次，系统只为类变量分配一次内存空间，执行一次初始化。程序可在两个地方对类变量执行初始化：

+ 定义类变量时指定初始值
+ 静态初始化代码块中对类变量指定初始值

这两种方式的执行顺序与它们在源代码中的排列顺序相同。

还是用上面那个示例，我们在其基础上加个被 static 修饰的变量 height：

1、`定义类变量时指定初始值` 在 `静态初始化代码块中对类变量指定初始值` 之后：

```java
public class A{
    double weight = 2.0;
    {
        weight = 2.1;
        System.out.println("我是代码块");
    }
    static{
        height = 10.1;
        System.out.println("我是静态代码块");
    }
    static double height = 10.0;
    public static void main(String[] args) {
        A a = new A();
        A a1 = new A();
        System.out.println(a.weight);
        System.out.println(height);
    }
}
```

运行结果：

```
我是静态代码块
我是代码块
我是代码块
2.1
10.0
```

2、`定义类变量时指定初始值` 在 `静态初始化代码块中对类变量指定初始值` 之前：

```java
public class A{
    static double height = 10.0;
    double weight = 2.0;
    {
        weight = 2.1;
        System.out.println("我是代码块");
    }
    static{
        height = 10.1;
        System.out.println("我是静态代码块");
    }
    public static void main(String[] args) {
        A a = new A();
        A a1 = new A();
        System.out.println(a.weight);
        System.out.println(height);
    }
}
```

运行结果：

```
我是静态代码块
我是代码块
我是代码块
2.1
10.1
```

其运行结果正如我们预料，但是我们还是看看反编译后的代码吧！

第一种情况下反编译的代码：

```java
public class A
{
  double weight;
  public A()
  {
    this.weight = 2.0D;

    this.weight = 2.1D;
    System.out.println("我是代码块");
  }
  static
  {
    System.out.println("我是静态代码块");
  }
  static double height = 10.0D;
  public static void main(String[] args)
  {
    A a = new A();
    A a1 = new A();
    System.out.println(a.weight);
    System.out.println(height);
  }
}
```

第二种情况下反编译的代码：

```java
public class A
{
  static double height = 10.0D;
  double weight;
  public A()
  {
    this.weight = 2.0D;

    this.weight = 2.1D;
    System.out.println("我是代码块");
  }
  static
  {
    height = 10.1D;
    System.out.println("我是静态代码块");
  }
  public static void main(String[] args)
  {
    A a = new A();
    A a1 = new A();
    System.out.println(a.weight);
    System.out.println(height);
  }
}
```

通过反编译源码，可以看到第一种情况下(`定义类变量时指定初始值` 在 `静态初始化代码块中对类变量指定初始值` 之后):

我们在 **静态初始化代码块中对类变量指定初始值** 已经不存在了，只有一个类变量指定的初始值 `static double height = 10.0D;` , 而在第二种情况下（`定义类变量时指定初始值` 在 `静态初始化代码块中对类变量指定初始值` 之前）和之前的源代码顺序是一样的，没啥区别。

上面的代码中充分的展示了类变量的两种初始化方式 ：每次运行该程序时，系统会为 A 类执行初始化，先为所有类变量分配内存空间，再按照源代码中的排列顺序执行静态初始代码块中所指定的初始值和定义类变量时所指定的初始值。

###  父类构造器

当创建任何 Java 对象时，程序总会先依次调用每个父类非静态初始化代码块、父类构造器（总是从 Object 开始）执行初始化，最后才调用本类的非静态初始化代码块、构造器执行初始化。

#### 隐式调用和显示调用

当调用某个类的构造器来创建 Java 对象时，系统总会先调用父类的非静态初始化代码块进行初始化。这个调用是隐式执行的，而且父类的静态初始化代码块总是会被执行。接着会调用父类的一个或多个构造器执行初始化，这个调用既可以是通过 super 进行显示调用，也可以是隐式调用。

当所有父类的非静态初始代码块、构造器依次调用完成后，系统调用本类的非静态代码块、构造器执行初始化，最后返回本类的实例。至于调用父类的哪个构造器执行初始化，分以下几种情况：

+ 子类构造器执行体的第一行代码使用 super 显式调用父类构造器，系统将根据 super 调用里传入的实参列表来确定调用父类的哪个构造器；
+ 子类构造器执行体的第一行代码使用 this 显式调用本类中的重载构造器，系统将根据 this 调用里传入的实参列表来确定奔雷的另一个构造器（执行本类中另一个构造器时即进入第一种情况）；
+ 子类构造器中既没有 super 调用，也没有 this 调用，系统将会在执行子类构造器之前，隐式调用父类无参构造器。

注：super 和 this 必须在构造器的第一行，且不能同时存在。

推荐一篇博客：[Java初始化顺序](http://www.cnblogs.com/miniwiki/archive/2011/03/25/1995615.html) 文章从无继承和继承两种情况下分析了 Java 初始化的顺序。


#### 访问子类对象的实例变量



#### 调用被子类重写的方法



### 父子实例的内存控制

#### 继承成员变量和继承方法的区别

方法的行为总是表现出它们实际类型的行为；实例变量的值总是表现出声明这些变量所用类型的行为。

#### 内存中的子类实例



#### 父、子类的类变量



### final 修饰符

final 可以修饰变量、方法、类。

+ 修饰变量，变量被赋初始值之后，不能够对他在进行修改
+ 修饰方法，不能够被重写
+ 修饰类，不能够被继承

final 修饰的实例变量只能在如下位置指定初始值：

+ 定义 final 实例变量时指定初始值
+ 在非静态代码块中为 final 实例变量指定初始值
+ 在构造器中为 final 实例变量指定初始值

final 修饰的类变量只能在如下位置指定初始值：

+ 定义 final 类变量时指定初始值
+ 在静态代码块中为 final 类变量指定初始值



## 第 3 课 —— 常见 Java 集合的实现细节

Java 集合框架类图：

![](http://ohfk1r827.bkt.clouddn.com/Java%E9%9B%86%E5%90%88%E6%A1%86%E6%9E%B6%E7%B1%BB%E5%9B%BE.jpg)

### Set 和 Map

Set 代表一种集合元素无序、集合元素不可重复的集合，Map 则代表一种由多个 key-value 对组合的集合，Map 集合类似于传统的关联数组。

#### Set 和 Map 的关系

1、Map 集合中的 key 不能重复且没有顺序。将这些 key 组合起来就是一个 Set 集合。所以有一个 `Set<k> keySet()` 方法来返回所有 key 组成的 Set 集合。

2、Set 也可以转换成 Map。（在 Set 中将 每一对 key 和 value 存放在一起）

#### HashMap 和 HashSet

HashSet：系统采用 Hash 算法决定集合元素的存储位置。（基于 HashMap 实现的）

HashMap：系统将 value 当成 key 的附属，系统根据 Hash 算法决定 key 的存储位置。

HashSet 的绝大部分方法都是通过调用 HashMap 的方法实现的，因此 HashSet 和 HashMap 两个集合在实现本质上是相同的。

#### TreeMap 和 TreeSet

TreeSet 底层使用 TreeMap 来包含 Set 集合中的所有元素。

TreeMap 采用的是一种“红黑树”的排序二叉树来保存 Map 中每个 Entry —— 每个 Entry 都被当成 “红黑树” 的一个节点对待。

### Map 和 List

#### Map 的 values() 方法

不管是 HashMap 还是 TreeMap ，它们的 values() 方法都可以返回其所有 value 组成的 Collection 集合，其实是一个不存储元素的 Collection 集合，当程序遍历 Collection 集合时，实际上就是遍历 Map 对象的 value。

HashMap 和 TreeMap 的 values() 方法并未把 Map 中的 values 重新组合成一个包含元素的集合对象，这样就可以降低系统内存开销。

#### Map 和 List 的关系

底层实现很相似；用法上很相似。

+ Map 接口提供 get(K key) 方法允许 Map 对象根据 key 来取得 value；
+ List 接口提供了 get(int index) 方法允许 List 对象根据元素索引来取得 value；

### ArrayList 和 LinkedList

List 集合的实现类，主要有 ArrayList 、Vector 和 LinkedList。

+ **ArrayList **是一个可改变大小的数组.当更多的元素加入到 ArrayList 中时, 其大小将会动态地增长.  内部的元素可以直接通过 get 与 set 方法进行访问, 因为 ArrayList 本质上就是一个数组.
+ **LinkedList **是一个双链表, 在添加和删除元素时具有比 ArrayList 更好的性能. 但在 get 与 set 方面弱于ArrayList. 当然, 这些对比都是指数据量很大或者操作很频繁的情况下的对比, 如果数据和运算量很小,那么对比将失去意义.
+ **Vector **和 ArrayList 类似, 但属于强同步类。如果你的程序本身是线程安全的(thread-safe,没有在多个线程之间共享同一个集合/对象),那么使用 ArrayList 是更好的选择。

Vector 和 ArrayList 在更多元素添加进来时会请求更大的空间。Vector 每次请求其大小的双倍空间，而 ArrayList每次对 size 增长 50%.

而 LinkedList 还实现了 Queue 接口, 该接口比 List 提供了更多的方法,包括 offer(), peek(), poll()等.

注意: 默认情况下 ArrayList 的初始容量非常小, 所以如果可以预估数据量的话, 分配一个较大的初始值属于最佳实践, 这样可以减少调整大小的开销。

ArrayList与LinkedList性能对比

时间复杂度对比如下:

![](http://www.programcreek.com/wp-content/uploads/2013/03/arraylist-vs-linkedlist-complexity.png)

LinkedList 更适用于:

+ 没有大规模的随机读取
+ 大量的增加/删除操作

### Iterator 迭代器

是一个迭代器接口，专门用于迭代各种 Collection 集合，包括 Set  集合和 List 集合。



## 第 4 课 —— Java 的内存回收

### Java 引用的种类

#### 对象在内存中的状态

JVM 垃圾回收机制，是否回收一个对象的标准在于：是否还有引用变量引用该对象？只要有引用变量引用该对象，垃圾回收机制就不会回收它。

Java 语言对对象的引用有：

+ 强引用
+ 软引用
+ 弱引用
+ 虚引用

#### 强引用

程序创建一个对象，并把这个对象赋给一个引用变量，这个引用变量就是强引用。当一个对象被一个或者一个以上的强引用变量所引用时，它处于可达状态，它是不会被系统的垃圾回收机制回收。

#### 软引用

软引用需要通过 SoftReference 类来实现，当一个对象只具有软引用时，它有可能会被垃圾回收机制回收。对于只有软引用的对象而言，当系统内存空间足够时，它不会被系统回收，程序也可使用该对象；当系统内存空间不足时，系统将会回收它。

#### 弱引用

弱引用和软引用有点相似，区别在于弱引用所引用对象的生存期更短。

#### 虚引用

虚引用主要用于跟踪对象被垃圾回收的状态，虚引用不能单独使用，虚引用必须和引用队列联合使用。

### Java 的内存泄漏

ArrayList.java 中的 remove 方法

```java
public E remove(int index) {
        rangeCheck(index);
        modCount++;
        E oldValue = elementData(index);
        int numMoved = size - index - 1;
        if (numMoved > 0)
            System.arraycopy(elementData, index+1, elementData, index,
                             numMoved);
        elementData[--size] = null; // clear to let GC do its work
        return oldValue;
    }
```

其中 `elementData[--size] = null; // clear to let GC do its work` 语句是清除数组元素的引用，避免内存的泄漏，如果没有这句的话，那么就是只有两个作用：

+ 修饰 Stack 的属性，也就是将值减 1；
+ 返回索引为 size -1 的值。

### 垃圾回收机制

+ 跟踪并监控每个 Java 对象，当某个对象处于不可达状态时，回收该对象所占用的内存。
+ 清理内存分配，回收过程中产生的内存碎片。

#### 垃圾回收的基本算法

对于一个垃圾回收器的设计算法来说，大概有如下几个设计：

+ 串行回收 和 并行回收

  > 串行回收：不管系统有多少个 CPU，始终使用一个 CPU 来执行垃圾回收操作
  >
  > 并行回收：把整个回收工作拆分成多部分，每个部分由一个 CPU 负责，从而让多个 CPU 并行回收

+ 并发执行 和 应用程序停止

+ 压缩 和 不压缩 和 复制

  > + 复制：将堆内分成两个相同的空间，从根开始访问每一个关联的可达对象，将空间A的可达对象全部复制到空间B，然后一次性回收整个空间A。
  > + 标记清除：也就是 不压缩 的回收方式。垃圾回收器先从根开始访问所有可达对象，将它们标记为可达状态，然后再遍历一次整个内存区域，把所有没有标记为可达的对象进行回收处理。
  > + 标记压缩：这是压缩方式，这种方式充分利用上述两种算法的优点，垃圾回收器先从根开始访问所有可达对象，将他们标记为可达状态，接下来垃圾回收器会将这些活动对象搬迁在一起，这个过程叫做内存压缩，然后垃圾回收机制再次回收那些不可达对象所占用的内存空间，这样就避免了回收产生的内存碎片。

#### 堆内存的分代回收

1、Young 代

2、Old 代

3、Permanent 代

### 内存管理小技巧

+ 尽量使用直接量
+ 使用 StringBuilder 和 StringBuffer 进行字符串拼接
+ 尽早释放无用对象的引用
+ 尽量少用静态变量
+ 避免在经常调用的方法、循环中创建 Java 对象
+ 缓存经常使用的对象
+ 尽量不要使用 finalize 方法
+ 考虑使用 SoftReference



## 第 5 课 —— 表达式中的陷阱

### 关于字符串的陷阱

#### JVM 对字符串的处理

`String java = new String("Java")` 这句创建了两个字符串对象，一个是 “Java” 这个直接量对应的字符串对象，另外一个是 new String() 构造器返回的字符串对象。

Java 程序中创建对象的方法：

+ 通过 new 调用构造器创建 Java 对象
+ 通过 Class 对象的 newInstance() 方法调用构造器创建 Java 对象
+ 通过 Java 的反序列化机制从 IO 流中恢复 Java 对象
+ 通过 Java 对象提供的 clone() 方法复制一个新的 Java 对象
+ 对于字符串以及 Byte、Short、Int、Long、Character、Float、Double 和 Boolean 这些基本类型的包装类
+ 直接量的方式来创建 Java 对象  Integer in = 5；
+ 通过简单的算法表达式，连接运算来创建 Java 对象 String str = "a" + "b"; （如果这个字符串表达式的值在编译时确定下来，那么 JVM 会在编译时计算该字符串变量的值，并让它指向字符串池中对应的字符串。如果这些算法表达式都是字符串直接量、整数直接量，没有变量和方法参与，那么就可以在编译期就可以确定字符串的值；如果使用了变量、调用了方法，那么只有等到运行时才能确定字符串表达式的值；如果字符串连接运算所有的变量都可执行 “宏替换”（使用 final 修饰的变量），那在编译时期也能确定字符串连接表达式的值）

对于 Java 程序的字符直接量，JVM 会使用一个字符串池来保护它们；当第一次使用某个字符串直接量时，JVM 会将它放入字符串池进行缓存。在一般的情况下，字符串池中的字符串对象不会被垃圾回收器回收，当程序再次需要使用该字符串时，无需重新创建一个新的字符串，而是直接让引用变量指向字符串池中已有的字符串。

#### 不可变的字符串

String 类是一个不可变类，当一个 String 对象创建完成后，该 String 类里包含的字符序列就被固定下来，以后永远不能修改。

如果程序需要一个字符序列会发生改变的字符串，那么建议使用 StringBuilder （效率比 StringBuffer 高）

#### 字符串比较

如果要比较两个字符串是否相同，用 == 进行判断就行，但如果要判断两个字符串所包含的字符序列是否相同，则应该用 String 重写过的 equals() 方法进行比较。

```java
public boolean equals(Object anObject) {
        //如果两个字符串相同
        if (this == anObject) {
            return true;
        }
        //如果anObject是String类型
        if (anObject instanceof String) {
            String anotherString = (String)anObject;
            //n代表字符串的长度
            int n = value.length;
            //如果两个字符串长度相等
            if (n == anotherString.value.length) {
                //获取当前字符串、anotherString底层封装的字符数组
                char v1[] = value;
                char v2[] = anotherString.value;
                int i = 0;
                //逐一比较v1 和 v2数组中的每个字符
                while (n-- != 0) {
                    if (v1[i] != v2[i])
                        return false;
                    i++;
                }
                return true;
            }
        }
        return false;
    }
```

还可以使用 String 提供的 compareTo() 方法返回两个字符串的大小

```java
public int compareTo(String anotherString) {
        int len1 = value.length;
        int len2 = anotherString.value.length;
        int lim = Math.min(len1, len2);
        char v1[] = value;
        char v2[] = anotherString.value;

        int k = 0;
        while (k < lim) {
            char c1 = v1[k];
            char c2 = v2[k];
            if (c1 != c2) {
                return c1 - c2;
            }
            k++;
        }
        return len1 - len2;
    }
```

### 表达式类型的陷阱

#### 表达式类型的自动提升

+ 所有 byte、short、char类型将被提升到 int 类型参与运算

+ 整个算术表达式的数据类型自动提升到与表达式中最高等级操作数同样的类型，操作数的等级排列如下：char -> int -> long ->float -> double

  byte -> short -> int -> long ->float -> double

#### 复合赋值运算符的陷阱

Java 语言允许所有的双目运算符和 = 一起结合组成复合赋值运算符，如 +=、-=、*=、/=、%= 、&= 等，复合赋值运算符包含了一个隐式的类型转换。

```java
//下面这两条语句不等价
a = a + 5;		//
a += 5;			//实际上等价于 a = (a的类型) (a + 5);
```

复合赋值运算符会自动的将它计算的结果值强制转换为其左侧变量的类型。

### 输入法导致的陷阱

### 注释的字符必须合法

### 转义字符的陷阱

+ 慎用字符的 Unicode 转义形式
+ 中止行注释的转义字符

### 泛型可能引起的错误

#### 原始类型变量的赋值

+ 当程序把一个原始类型的变量赋给一个带有泛型信息的变量时，总是可以通过编译（只是会提示警告信息）
+ 当程序试图访问带泛型声明的集合的集合元素时，编译器总是把集合元素当成泛型类型处理（它并不关心集合里集合元素的实际类型）
+ 当程序试图访问带泛型声明的集合的集合元素时，JVM会遍历每个集合元素自动执行强制转型，如果集合元素的实际类型与集合所带的泛型信息不匹配，运行时将引发 ClassCastException

#### 原始类型带来的擦除

当把一个具有泛型信息的对象赋给另一个没有泛型信息的变量时，所有在尖括号之间的类型信息都会丢弃。

#### 创建泛型数组的陷阱

Java 中不允许创建泛型数组

### 正则表达式的陷阱

有些符号本身就是正则表达式，我们需要对符号做转义运算。

### 多线程的陷阱

#### 不要调用 run 方法

开启线程是用 start() 方法，而不是 run() 方法。

#### 静态的同步方法

对于同步代码块而言，程序必须显式为它指定同步监视器；对于同步非静态方法而言，该方法的同步监视器是 this —— 即调用该方法的 Java 对象；对于静态的同步方法而言，该方法的同步监视器不是 this，而是该类本身。





## 第 6 课 —— 流程控制的陷阱

### switch 语句陷阱

break 语句不要忘记写

switch 的表达式类型：

+ byte
+ short
+ int
+ char
+ enum
+ String （Jdk 1.7 以后有 String）

### 标签引起的陷阱

Java 中的标签通常是和循环中的 break 和 continue 结合使用，让 break 直接终止标签所标识的循环，让 continue 语句忽略标签所标识的循环的剩下语句。

。。



## 第 7 课 —— 面向对象的陷阱

### instanceof  运算符的陷阱

instanceof 它用于判断前面的对象是否是后面的类或其子类、实现类的实例。如果是返回 true，否则返回 false。

instanceof 运算符前面操作数的编译时类型必须是：

+ 要么与后面的类相同
+ 要么是后面类的父类
+ 要么是后面类型的子类


### 构造器陷阱

构造器是 Java 中每个类都会提供的一个“特殊方法”。构造器负责对 Java 对象执行初始化操作，不管是定义实例变量时指定的初始值，还是在非静态初始化代码块中所做的操作，实际上都会被提取到构造器中执行。

构造器不能声明返回值类型，也不能使用void声明构造器没有返回值。

#### 构造器创建对象吗

构造器并不会创建 Java 对象，构造器只是负责执行初始化，在构造器执行之前，Java 对象所需要的内存空间，是由 new 关键字申请出来的。绝大部分时候，程序使用 new 关键字为一个 Java 对象申请空间之后，都需要使用构造器为这个对象执行初始化，但在某些时候，程序创建 Java 对象无需调用构造器，如下：

+ 使用反序列化的方式恢复 Java 对象
+ 使用 clone 方法复制 Java 对象

```java
package com.zhisheng.test;

import java.io.*;

/**
 * Created by 10412 on 2017/5/31.
 */
class Wolf implements Serializable
{
    private String name;

    public Wolf(String name) {
        System.out.println("调用了有参构造方法");
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Wolf wolf = (Wolf) o;

        return name != null ? name.equals(wolf.name) : wolf.name == null;

    }

    @Override
    public int hashCode() {
        return name != null ? name.hashCode() : 0;
    }
}

public class SerializableTest
{
    public static void main(String[] args) {
        Wolf w = new Wolf("灰太狼");
        System.out.println("对象创建完成");
        Wolf w2 = null;
        ObjectInputStream ois = null;
        ObjectOutputStream oos = null;
        try {
            //创建输出对象流
            oos = new ObjectOutputStream(new FileOutputStream("a.bin"));
            //创建输入对象流
            ois = new ObjectInputStream(new FileInputStream("a.bin"));
            //序列输出java 对象
            oos.writeObject(w);
            oos.flush();
            //反序列化恢复java对象
            w2 = (Wolf) ois.readObject();
            System.out.println(w);
            System.out.println(w2);
            //两个对象的实例变量值完全相等，输出true
            System.out.println(w.equals(w2));
            //两个对象不同，输出false
            System.out.println(w == w2);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }finally {
            if (ois!=null)
                try {
                    ois.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            if (oos!=null)
                try {
                    oos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
        }

    }
}
```

程序运行结果：

```java
调用了有参构造方法
对象创建完成
com.zhisheng.test.Wolf@1b15382
com.zhisheng.test.Wolf@1b15382
true
false
```

正如结果所示：创建 Wolf 对象时，程序调用了相应的构造器来对该对象执行初始化；当程序通过反序列化机制恢复 Java 对象时，系统无需在调用构造器来进行初始化。通过反序列化恢复出来的 Wolf 对象和原来的 Wolf 对象具有完全相同的实例变量值，但系统会产生两个对象。

#### 无限递归构造器

```java
public class ConstrutionTest
{
    ConstrutionTest ct;
    {
        ct = new ConstrutionTest();
    }
    public ConstrutionTest() {
        System.out.println("无参构造器");
    }
    public static void main(String[] args) {
        ConstrutionTest ct = new ConstrutionTest();
    }
}
```

运行结果抛出异常 `java.lang.StackOverflowError`

因为不管定义实例变量时指定的初始值，还是在非静态初始化代码块中执行的初始化操作，最终都将提取到构造器中执行，因为代码中递归调用了类的构造器，最终导致出现 `java.lang.StackOverflowError` 异常。

### 到底调用哪个重载方法

1、第一阶段 JVM 将会选取所有可获得并匹配调用的方法或者构造器

2、第二个阶段决定到底要调用哪个方法，此时 JVM 会在第一阶段所选取的方法或者构造器中再次选取最精确匹配的那一个。

```java
public class OverrideTest
{
    public void info(Object obj, int a) {
        System.out.println("obj 参数" + obj);
        System.out.println("整型参数 " + a);
    }

    public void info(Object[] obj, double a) {
        System.out.println("obj 参数" + obj);
        System.out.println("整型参数 " + a);
    }

    public static void main(String[] args) {
        OverrideTest o = new OverrideTest();
        o.info(null, 5);
    }
}
```

报错如下：

```
Error:(20, 10) java: 对info的引用不明确
  com.zhisheng.test.OverrideTest 中的方法 info(java.lang.Object,int) 和 com.zhisheng.test.OverrideTest 中的方法 info(java.lang.Object[],double) 都匹配
```

在这种复杂的条件下，JVM 无法判断哪个方法更匹配实际调用，将会导致程序编译错误。

### 方法重写的陷阱

无法重写父类 private 方法。如果子类有一个与父类 private 方法具有相同方法名、相同形参列表、相同返回值类型的方法，依然不是重写，只是子类定义了一个与父类相同的方法。

### static 关键字

static 可以修饰类中定义的成员：field、方法、内部类、初始化代码块、内部枚举类

#### 静态方法属于类

被 static 修饰的成员（field、方法、内部类、初始化块、内部枚举类）属于类本身，而不是单个的 Java 对象。静态方法也是属于类。



## 第 8 课 —— 异常捕捉的陷阱

### 正确关闭资源的方式

+ 使用 finally 块来保证回收，保证关闭操作总是会被执行
+ 关闭每个资源之前首先保证引用该资源的引用变量不为 null
+ 为每个物理资源单独使用 try .. catch 块关闭资源，保证关闭资源时引发的异常不会影响其他资源的关闭。

### finally 块陷阱

finally 执行顺序，看我以前写的一篇文章[《深度探究Java 中 finally 语句块》](http://www.54tianzhisheng.cn/2017/03/28/%E6%B7%B1%E5%BA%A6%E6%8E%A2%E7%A9%B6Java%20%E4%B8%AD%20finally%20%E8%AF%AD%E5%8F%A5%E5%9D%97/)。

### catch 块用法

在 try 块后使用 catch 块来捕获多个异常时，程序应该小心多个 catch 块之间的顺序：捕获父类异常的 catch 块都应该排在捕获子类异常的 catch 块之后（先处理小异常，再处理大异常），否则出现编译错误。

### 继承得到的异常

子类重写父类方法时，不能声明抛出比父类方法类型更多、范围更大的异常。


二叉树性质：

+ 二叉树第 i 层上的节点数目至多为 2 ^(i - 1)   (i >= 1)

+ 深度为 k 的二叉树至多有 2 ^ k - 1 个节点

+ 在任何一颗二叉树中，如果其叶子结点的数量为 n0，度为 2 的子节点数量为 n2，则 n0 = n2 + 1

+ 具有 n 个节点的完全二叉树的深度为 log n   +  1   (log 的底为 2)

+ 对于一棵有 n 个节点的完全二叉树的节点按层自左向右编号，则对任一编号为 i 的节点有如下性质：

  当 i == 1 时，节点 i 是二叉树的根；若 i > 1 时，则节点的父节点是 i/2

  当 2i <= n，则节点 i 有左孩子，左孩子的编号是 2i，否则，节点无左孩子，并且是叶子结点

  若 2i + 1 <= n ，则节点 i 有右孩子，右孩子的编号是 2i + 1；否则，节点无右孩子。

+ 对于一颗 n 个节点的完全二叉树的节点按层自左向右编号，1 ~ n/2 范围的节点都是有孩子节点的非叶子结点，其余的节点全部都是叶子结点。编号为 n/2 的节点有可能只有左节点，也可能既有左节点，又有右节点。



### 选择排序

#### 直接选择排序

需要经过 n - 1 趟比较

第一趟比较：程序将记录定位在第一个数据上，拿第一个数据依次和它后面的每个数据进行比较，如果第一个数据大于后面某个数据，交换它们。。依此类推，经过第一趟比较，这组数据中最小的数据被选出来，它被排在第一位。

第二趟比较：程序将记录定位在第二个数据上，拿第二个数据依次和它后面每个数据进行比较，如果第二个数据大于后面某个数据，交换它们。。依次类推，经过第二趟比较，这组数据中第二小的数据被选出，它排在第二位

。。

按此规则一共进行 n-1 趟比较，这组数据中第 n - 1小（第二大）的数据被选出，被排在第 n -1 位（倒数第一位）；剩下的就是最大的数据，它排在最后。

直接选择排序的优点就是算法简单，容易实现，缺点就是每趟只能确定一个元素，n个数组需要进行 n-1 趟比较。

#### 堆排序

+ 建堆
+ 拿堆的根节点和最后一个节点交换

### 交换排序

#### 冒泡排序

第一趟：依次比较0和1，1和2，2和3 ... n-2 和 n - 1 索引的元素，如果发现第一个数据大于后一个数据，交换它们，经过第一趟，最大的元素排到了最后。

第二趟：依次比较0和1，1和2，2和3 ... n-3 和 n - 2 索引的元素，如果发现第一个数据大于后一个数据，交换它们，经过第二趟，第二大的元素排到了倒数第二位

。。

第 n -1 趟：依次比较0和1元素，如果发现第一个数据大于后一个数据，交换它们，经过第 n - 1 趟，第二小的元素排到了第二位。

#### 快速排序

从待排的数据序列中任取一个数据作为分界值，所有比它小的数据元素一律放在左边，所有比他大的元素一律放在右边，这样一趟下来，该序列就分成了两个子序列，接下来对两个子序列进行递归，直到每个子序列只剩一个，排序完成。

### 插入排序

#### 直接插入排序

依次将待排序的数据元素按其关键字值的大小插入前面的有序序列。

#### 折半插入排序

当第 i - 1 趟需要将第 i 个元素插入前面的 0 ~ i -1 个元素序列中时：

+ 计算 0 ~ i - 1 索引的中间点，也就是用 i 索引处的元素和 （0 + i - 1）/2 索引处的元素进行比较，如果 i 索引处的元素大，就直接在 （（0 + i - 1）/2 ） ~ （i - 1）后半个范围内进行搜索，反之在前半个范围搜索。
+ 重复上面步骤
+ 确定第 i 个元素的插入位置，就将该位置的后面所有元素整体后移一位，然后将第 i 个元素放入该位置。
', 1, 'post', 'publish', 'Java', 'Java', 20, 0, 1, 1, 1);


CREATE TABLE blog.t_logs
(
    id int(11) unsigned PRIMARY KEY NOT NULL AUTO_INCREMENT,
    action varchar(100),
    data varchar(2000),
    author_id int(10),
    ip varchar(20),
    created int(10)
);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (1, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1496815277);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (2, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1496815280);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (3, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1496815318);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (4, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1496815398);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (5, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1496815482);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (6, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1496815492);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (7, '保存系统设置', '{"site_keywords":"Blog","site_description":"SpringBoot+Mybatis+thymeleaf 搭建的 Java 博客系统","site_title":"Blog","site_theme":"default","allow_install":""}', 1, '0:0:0:0:0:0:0:1', 1496815955);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (8, '保存系统设置', '{"site_keywords":"Blog","site_description":"SpringBoot+Mybatis+thymeleaf 搭建的 Java 博客系统","site_title":"Blog","site_theme":"default","allow_install":""}', 1, '0:0:0:0:0:0:0:1', 1496815964);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (9, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1496989015);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (10, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1496989366);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (11, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497317863);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (12, '保存系统设置', '{"social_zhihu":"https://www.zhihu.com/people/tian-zhisheng/activities","social_github":"https://github.com/zhisheng17","social_twitter":"","social_weibo":""}', 1, '0:0:0:0:0:0:0:1', 1497318696);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (13, '修改个人信息', '{"uid":1,"email":"1041218129@qq.com","screenName":"admin"}', 1, '0:0:0:0:0:0:0:1', 1497319220);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (14, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497319856);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (15, '登录后台', null, 1, '127.0.0.1', 1497321561);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (16, '登录后台', null, 1, '127.0.0.1', 1497322738);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (17, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497323446);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (18, '删除文章', '2', 1, '0:0:0:0:0:0:0:1', 1497323495);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (19, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497427641);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (20, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497428250);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (21, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497428290);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (22, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497428556);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (23, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497674581);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (24, '修改个人信息', '{"uid":1,"email":"1041218129@qq.com","screenName":"admin"}', 1, '0:0:0:0:0:0:0:1', 1497674690);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (25, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497676623);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (26, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497683817);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (27, '登录后台', null, 1, '0:0:0:0:0:0:0:1', 1497685128);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (28, '登录后台', null, 1, '127.0.0.1', 1497689032);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (29, '登录后台', null, 1, '124.90.54.111', 1546584935);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (30, '保存系统设置', '{"social_zhihu":"","social_github":"https://github.com/Fadezed","social_twitter":"","social_weibo":""}', 1, '124.90.54.111', 1546584966);
INSERT INTO blog.t_logs (id, action, data, author_id, ip, created) VALUES (31, '删除文章', '/upload/2017/06/t93vgdj6o8irgo87ds56u0ou0s.jpeg', 1, '124.90.54.111', 1546585000);


CREATE TABLE blog.t_metas
(
    mid int(10) unsigned PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(200),
    slug varchar(200),
    type varchar(32) DEFAULT '' NOT NULL,
    description varchar(200),
    sort int(10) unsigned DEFAULT '0',
    parent int(10) unsigned DEFAULT '0'
);
CREATE INDEX slug ON blog.t_metas (slug);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (1, 'default', null, 'category', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (6, 'my github', 'https://github.com/Fadezed', 'link', 'http://www.54tianzhisheng.cn/img/avatar.png', 1, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (8, '随笔', '随笔', 'tag', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (9, 'Java', 'Java', 'tag', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (10, 'Java', 'Java', 'category', '有关Java的博客', 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (11, 'HashMap', 'HashMap', 'tag', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (12, 'HashTable', 'HashTable', 'tag', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (13, 'HashSet', 'HashSet', 'tag', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (14, 'ConcurrentHashMap', 'ConcurrentHashMap', 'tag', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (15, 'Pyspider', 'Pyspider', 'tag', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (16, 'Python', 'Python', 'tag', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (17, '爬虫', '爬虫', 'tag', null, 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (19, 'Python', 'Python', 'category', '有关Python的博客', 0, 0);
INSERT INTO blog.t_metas (mid, name, slug, type, description, sort, parent) VALUES (20, '随笔', null, 'category', null, 0, 0);


CREATE TABLE blog.t_options
(
    name varchar(32) DEFAULT '' PRIMARY KEY NOT NULL,
    value varchar(1000) DEFAULT '',
    description varchar(200)
);
INSERT INTO blog.t_options (name, value, description) VALUES ('allow_install', '', '');
INSERT INTO blog.t_options (name, value, description) VALUES ('site_description', 'SpringBoot+Mybatis+thymeleaf 搭建的 Java 博客系统', null);
INSERT INTO blog.t_options (name, value, description) VALUES ('site_keywords', 'Blog', null);
INSERT INTO blog.t_options (name, value, description) VALUES ('site_theme', 'default', null);
INSERT INTO blog.t_options (name, value, description) VALUES ('site_title', 'Blog', '');
INSERT INTO blog.t_options (name, value, description) VALUES ('social_github', 'https://github.com/Fadezed', null);
INSERT INTO blog.t_options (name, value, description) VALUES ('social_twitter', '', null);
INSERT INTO blog.t_options (name, value, description) VALUES ('social_weibo', '', null);
INSERT INTO blog.t_options (name, value, description) VALUES ('social_zhihu', '', null);



CREATE TABLE blog.t_relationships
(
    cid int(10) unsigned NOT NULL,
    mid int(10) unsigned NOT NULL,
    CONSTRAINT `PRIMARY` PRIMARY KEY (cid, mid)
);
INSERT INTO blog.t_relationships (cid, mid) VALUES (3, 9);
INSERT INTO blog.t_relationships (cid, mid) VALUES (3, 10);
INSERT INTO blog.t_relationships (cid, mid) VALUES (4, 9);
INSERT INTO blog.t_relationships (cid, mid) VALUES (4, 10);
INSERT INTO blog.t_relationships (cid, mid) VALUES (4, 11);
INSERT INTO blog.t_relationships (cid, mid) VALUES (4, 12);
INSERT INTO blog.t_relationships (cid, mid) VALUES (4, 13);
INSERT INTO blog.t_relationships (cid, mid) VALUES (4, 14);
INSERT INTO blog.t_relationships (cid, mid) VALUES (5, 1);
INSERT INTO blog.t_relationships (cid, mid) VALUES (5, 15);
INSERT INTO blog.t_relationships (cid, mid) VALUES (5, 16);
INSERT INTO blog.t_relationships (cid, mid) VALUES (5, 17);
INSERT INTO blog.t_relationships (cid, mid) VALUES (6, 9);
INSERT INTO blog.t_relationships (cid, mid) VALUES (6, 10);



CREATE TABLE blog.t_users
(
    uid int(10) unsigned PRIMARY KEY NOT NULL AUTO_INCREMENT,
    username varchar(32),
    password varchar(64),
    email varchar(200),
    home_url varchar(200),
    screen_name varchar(32),
    created int(10) unsigned DEFAULT '0',
    activated int(10) unsigned DEFAULT '0',
    logged int(10) unsigned DEFAULT '0',
    group_name varchar(16) DEFAULT 'visitor'
);
CREATE UNIQUE INDEX name ON blog.t_users (username);
CREATE UNIQUE INDEX mail ON blog.t_users (email);
INSERT INTO blog.t_users (uid, username, password, email, home_url, screen_name, created, activated, logged, group_name) VALUES (1, 'admin', 'a66abb5684c45962d887564f08346e8d', '1041218129@qq.com', null, 'admin', 1490756162, 0, 0, 'visitor');