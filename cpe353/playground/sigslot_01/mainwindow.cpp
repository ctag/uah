#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    //setWindowTitle(tr("slider test"));

    ui->setupUi(this);

    setWindowTitle(tr("slider test"));

    connect(ui->horizontalSlider, SIGNAL(valueChanged(int)), ui->horizontalSlider_2, SLOT(setValue(int)));

}

MainWindow::~MainWindow()
{
    delete ui;
}
