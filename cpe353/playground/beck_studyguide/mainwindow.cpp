#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    
    arrowEventFilter = new ArrowEventFilter();
    
    /*
     * Property Manipulation
     */
    ui->a1b1label->setText("Chargers");
    ui->a1b1label->setFrameShape(QFrame::Box);
    
    /*
     * Signal/Slots
     */
    connect(ui->a1b2spinbox, SIGNAL(valueChanged(int)), ui->a1b2slider, SLOT(setValue(int)));
    connect(ui->a1b2slider, SIGNAL(valueChanged(int)), ui->a1b2spinbox, SLOT(setValue(int)));
    connect(ui->a1b3dial, &QDial::valueChanged, ui->a1b3spinbox, &QSpinBox::setValue);
    connect(ui->a1b3spinbox, static_cast<void (QSpinBox::*)(int)>(&QSpinBox::valueChanged), ui->a1b3dial, &QDial::setValue);
    
    ui->a1b6textedit->installEventFilter(arrowEventFilter);
    
}

bool ArrowEventFilter::eventFilter(QObject *obj, QEvent *event)
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

MainWindow::~MainWindow()
{
    delete ui;
}



























