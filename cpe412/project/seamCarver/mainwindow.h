#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <math.h>
#include <stdlib.h>
#include <omp.h>
#include <pthread.h>

#include <QMainWindow>
#include <QImage>
#include <QtDebug>
#include <QGraphicsView>
#include <QGraphicsScene>
#include <QPixmap>
#include <QGraphicsPixmapItem>
#include <QColor>
#include <QVector>
#include <QElapsedTimer>
#include <QFileDialog>
#include <QApplication>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    int getBrightness(int x, int y);
    void setBrightness(int x, int y, int value);
    int getEnergy(int x, int y);
    void setEnergy(int x, int y, int value);
    int getPath(int x, int y);
    int getLowestPathIndex(int startX, int endX);
    int getNearestLateral(int x, int y);
    void setMask(int x, int y, bool value);
    bool getMask(int x, int y);
    void setPath(int x, int y, int value);
    void serialGenEnergy();
    void serialGenBrightness();
    void serialGenPath();
    void serialGenMask();
    void serialGenMod();
    void ompGenEnergy();
    void ompGenBrightness();
    void ompGenPath();
    void ompGenMask();
    void ompGenMod();
    static void * pthreadBootstrap(void * arg);
    void *pthreadManager();
    void pthreadGenEnergy(int rank);
    void pthreadGenBrightness(int rank);
    void pthreadGenPath(int rank);
    void pthreadGenMask(int rank);
    void pthreadGenMod(int rank);
    void setParallel(const QString method);

public slots:
    void doLoadImage();
    void doProcResize();
    void doHandleRadioSerial();
    void doHandleRadioOmp();
    void doHandleRadioPthreads();

private:
    Ui::MainWindow *ui;
    QElapsedTimer timer;
    QString imagePath;
    int origWidth;
    int origHeigth;
    int modWidth;
    int threadCount;
    int threadRankAssign;
    long thread;
    pthread_t * thread_handles;
    pthread_mutex_t mutex;
    pthread_barrier_t barrier;
    QImage * origImage;
    QPixmap * origPix;
    QGraphicsScene * origScene;
    QImage * energyImage;
    QPixmap * energyPix;
    QGraphicsScene * energyScene;
    QImage * modImage;
    QPixmap * modPix;
    QGraphicsScene * modScene;
    QVector<int> brightnessGrid;
    QVector<int> energyGrid;
    QVector<int> pathGrid;
    QVector<bool> maskGrid;

};

#endif // MAINWINDOW_H
