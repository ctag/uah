#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QSqlDatabase>
#include <QLabel>
#include <QSql>
#include <QtSql>
#include <QSqlDatabase>
#include <QIntValidator>
#include <QtDebug>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QTableView>
#include <QSqlError>
#include <QAction>
#include <QSqlTableModel>
#include <QPainter>
#include <QPixmap>
#include <QPen>
#include <QBrush>
#include <QRect>
#include <QIntValidator>
#include <QRegularExpressionValidator>
#include <QDoubleValidator>
#include <QTextBrowser>
#include <QTextEdit>
#include <QInputEvent>
#include <QKeyEvent>
#include <stdio.h>
#include <stdlib.h>
#include <QTimer>
//#include <QTgui>
//#include <QUdpSocket>
//#include <QtNetwork>

/*
class EventFilter1 : public QObject
{
    Q_OBJECT
    
protected:
    bool eventFilter(QObject *obj, QEvent *event);
};
*/

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    QSqlDatabase db;
    QSqlQuery * dbQuery;
    QAction * dbOpened;
    QTableView * tview;
    QSqlTableModel * tmodel;
    QRegularExpressionValidator *regExpValid;
    QTimer *timer;

protected slots:
    void openDB();
    void toggleYesNo();
    void timerRadio();
    void timerStart();
    void timerStop();
    
signals:
    //void valueIncrement();
    
protected:
    bool eventFilter(QObject *obj, QEvent *event);
    int *filter_count;
    
private:
    Ui::MainWindow *ui;
    
};

#endif // MAINWINDOW_H
