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
    ui->events_textEdit->installEventFilter(this);
    regExpValid = new QRegularExpressionValidator(QRegularExpression("[24680]{0,1}"), ui->widgets_lineEdit);
    ui->widgets_lineEdit->setValidator(regExpValid);
    filter_count = new int;
    filter_count = 0;
    ui->statusBar->setStatusTip("Ready");
    qDebug() << ui->statusBar->statusTip();
    tview = new QTableView;
    tmodel = new QSqlTableModel;
    timer = new QTimer;
    
    
            
            
    /*
     * Signal/Slots
     */
    connect(ui->widgets_spinBox, SIGNAL(valueChanged(int)), ui->widgets_horizontalSlider, SLOT(setValue(int)));
    connect(ui->widgets_horizontalSlider, SIGNAL(valueChanged(int)), ui->widgets_spinBox, SLOT(setValue(int)));
    connect(ui->widgets_pushButton, SIGNAL(clicked()), this, SLOT(toggleYesNo()));
    connect(ui->actionQuit, SIGNAL(triggered()), this, SLOT(close()));
    connect(ui->sql_pushButton_tableview, SIGNAL(clicked()), this, SLOT(openDB()));
    connect(timer, SIGNAL(timeout()), this, SLOT(timerRadio()));
    connect(ui->timers_pushButton_start, SIGNAL(clicked()), this, SLOT(timerStart()));
    connect(ui->timers_pushButton_stop, SIGNAL(clicked()), this, SLOT(timerStop()));
    //connect(ui->, static_cast<void (QSpinBox::*)(int)>(&QSpinBox::valueChanged), ui->, &QDial::setValue);
    
    
    
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::toggleYesNo()
{
    qDebug() << "toggleYesNo SLOT.";
    if (ui->widgets_pushButton->text() == "No")
    {
        ui->widgets_pushButton->setText("Yes");
    } else {
        ui->widgets_pushButton->setText("No");
    }
}

/* Well fuck me for doing it right, never mind then.
bool EventFilter1::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::KeyPress) {
        QKeyEvent *ke = static_cast<QKeyEvent*>(event);
        //qDebug("Ate key press");
        if (ke->key() == Qt::Key_Backspace)
        {
            QString check = "Ready";
            if (MainWindow::ui->statusBar->statusTip() == check)
            {
                qDebug() << "bkfdsjfklsd";
            }
            return true;
        } else {
            // standard event processing
            return QObject::eventFilter(obj, event);
        }
    } else {
        // standard event processing
        return QObject::eventFilter(obj, event);
    }
}
*/
bool MainWindow::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::KeyPress) {
        QKeyEvent *ke = static_cast<QKeyEvent*>(event);
        
        if (ke->key() == Qt::Key_Backspace)
        {
            filter_count++;
            qDebug() << "backspace: " << filter_count;
            //char * newstatus = "";
            //printf(newstatus, "%d", filter_count);
            //ui->statusBar->setStatusTip("newstatus");
            /*QString check = "Ready";
            if (ui->statusBar->statusTip() == check)
            {
                qDebug() << "bkfdsjfklsd";
            }*/
            return true;
        } else {
            // standard event processing
            return QObject::eventFilter(obj, event);
        }
    } else {
        // standard event processing
        return QObject::eventFilter(obj, event);
    }
}

void MainWindow::timerRadio()
{
    //if (ui->timers_radioButton->isChecked())
    //{
      ui->timers_radioButton->toggle();
    //}
}

void MainWindow::timerStart() 
{
    int toset = ui->timers_spinBox->value();
    timer->start(toset);
}

void MainWindow::timerStop() 
{
    timer->stop();
}

void MainWindow::openDB()
{
    QString name, host, username, password, table;
    
    name = "";
    host = "";
    username = "";
    password = "";
    table = "";
    
    int port = 0;
    
    host.append(ui->sql_lineEdit_host->text());
    qDebug() << "Database host: " << host;
    
    port = ui->sql_lineEdit_port->value();
    qDebug() << "Database port: " << port;
    
    name.append(ui->sql_lineEdit_name->text());
    qDebug() << "Database name: " << name;
    
    username.append(ui->sql_lineEdit_username->text());
    qDebug() << "Database username: " << username;
    
    password.append(ui->sql_lineEdit_password->text());
    qDebug() << "Database password: " << password;
    
    table.append(ui->sql_lineEdit_table->text());
    qDebug() << "Database table: " << table;
    
    db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName(host);
    db.setDatabaseName(name);
    db.setPort(port);
    db.setUserName(username);
    db.setPassword(password);
    
    if (!db.open()) {
        qDebug() << "Database FAILED to open.";
        qDebug() << db.lastError();
    } else {
        qDebug() << "Database opened.";
        dbQuery = new QSqlQuery;
        
        tmodel->setTable(table);
        tmodel->select();
        tmodel->setEditStrategy(QSqlTableModel::OnManualSubmit);
        
        ui->sql_tableView->setModel(tmodel);
        //ui->sql_tableView->show();
        
    }
    
}






















