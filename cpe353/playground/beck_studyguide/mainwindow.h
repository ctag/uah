#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QDebug>

class ArrowEventFilter : public QObject
{
    Q_OBJECT
    
protected:
    bool eventFilter(QObject *obj, QEvent *event);
};

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    ArrowEventFilter *arrowEventFilter;

protected:
    //bool eventFilter(QObject *obj, QEvent *event);
    
private slots:

signals:
    void customSignal();
    
private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
