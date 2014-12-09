#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QSqlDatabase>
#include <QLabel>
#include <QSql>
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
    //bool EventFilter1 *eventFilter1;
    QSqlDatabase db;
    QSqlQuery * dbQuery;
    QAction * dbOpened;
    QTableView * tview;
    QSqlTableModel * tmodel;

protected slots:
    //void openDB();
    
signals:
    //void valueReached();
    
private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
