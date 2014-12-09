#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    
    /*
     * members
     */
    //eventFilter1 = new EventFilter1();
    
    /*
     * Signal/Slots
     */
    //connect(ui->a1b2spinbox, SIGNAL(valueChanged(int)), ui->a1b2slider, SLOT(setValue(int)));
    //connect(ui->a1b3dial, &QDial::valueChanged, ui->a1b3spinbox, &QSpinBox::setValue);
    //connect(ui->a1b3spinbox, static_cast<void (QSpinBox::*)(int)>(&QSpinBox::valueChanged), ui->a1b3dial, &QDial::setValue);
    
    
    
}

MainWindow::~MainWindow()
{
    delete ui;
}

/*
bool EventFilter1::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::KeyPress) {
        //QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
        qDebug("Ate key press");
        return true;
    } else {
        // standard event processing
        return QObject::eventFilter(obj, event);
    }
}
*/

/*
void MainWindow::openDB()
{
    QString name;
    name = "";
    name.append(ui->dbEdit->text());
    qDebug() << "Database name: " << name;
    
    db = QSqlDatabase::addDatabase("QSQLITE");
    
    db.setDatabaseName(name);
    
    if (!db.open()) {
        qDebug() << "Database FAILED to open.";
        qDebug() << db.lastError();
    } else {
        qDebug() << "Database opened.";
        dbOpened->setStatusTip("SQLite database opened");
        dbOpened->showStatusText();
        dbQuery = new QSqlQuery;
    }
}
*/






















