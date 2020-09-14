package Api;

class Shop {
    private int bread = 0;

    public synchronized void produceBread() {
        if (bread < 10) {
            bread++;
            System.out.println(Thread.currentThread().getName() + ":开始生产第" + bread + "个面包");
            notify(); // 唤醒消费者
        } else {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized void consumeBread() {
        if (bread > 0) {
            System.out.println(Thread.currentThread().getName() + ":开始消费第" + bread + "个面包");
            bread--;
            notify(); // 唤醒生产者线程
        } else {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

class Producer extends Thread {
    private Shop shop;

    public Producer(Shop shop) {
        this.shop = shop;
    }

    @Override
    public void run() {
        System.out.println(getName() + ":开始生产面包.....");
        while (true) {
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            shop.produceBread();
        }
    }
}

class Consumer extends Thread {
    private Shop shop;
    public Consumer(Shop shop) {
        this.shop = shop;
    }

    @Override
    public void run() {
        System.out.println(getName() + ":开始消费面包.....");
        while (true) {
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            shop.consumeBread();
        }
    }
}

public class BreadTest {
    public static void main(String[] args) {
        Shop shop = new Shop();
        Producer p1 = new Producer(shop);
        p1.setName("生产者");
        Consumer c1 = new Consumer(shop);
        c1.setName("消费者");

        p1.start();
        c1.start();
    }
}
