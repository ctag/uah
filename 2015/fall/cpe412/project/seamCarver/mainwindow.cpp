#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // Allocate images and scenes
    // QImage is used to manipulate image data
    // QPixmap is used to load that image data into a scene
    // QGraphicsScene is used to display the image on the UI
    origImage = new QImage();
    origPix = new QPixmap();
    origScene = new QGraphicsScene(this);
    resizeImage = new QImage();
    resizePix = new QPixmap();
    resizeScene = new QGraphicsScene(this);
    energyImage = new QImage();
    energyPix = new QPixmap();
    energyScene = new QGraphicsScene(this);
    modImage = new QImage();
    modPix = new QPixmap();
    modScene = new QGraphicsScene(this);

    // Connect the QGraphicsScene variables to the UI
    ui->graphicsView_orig->setScene(origScene);
    ui->graphicsView_resize->setScene(resizeScene);
    ui->graphicsView_energy->setScene(energyScene);
    ui->graphicsView_mod->setScene(modScene);

    // Set up UI signals->slots
    connect(ui->pushButton_imageSelect, SIGNAL(clicked()), this, SLOT(doLoadImage()));
    connect(ui->pushButton_doResize, SIGNAL(clicked()), this, SLOT(doProcResize()));
    connect(ui->radioButton_algSerial, SIGNAL(clicked()), this, SLOT(doHandleRadioSerial()));
    connect(ui->radioButton_algOmp, SIGNAL(clicked()), this, SLOT(doHandleRadioOmp()));
    connect(ui->radioButton_algPthreads, SIGNAL(clicked()), this, SLOT(doHandleRadioPthreads()));

    // Set initial UI state
    ui->radioButton_algSerial->setChecked(1);
    ui->radioButton_algOmp->setChecked(0);
    ui->radioButton_algPthreads->setChecked(0);
    ui->pushButton_doResize->setEnabled(0);
}

MainWindow::~MainWindow()
{
    delete ui;
}

// Slot which captures the load image pushbutton
void MainWindow::doLoadImage()
{
    // Display file selection window
    imagePath = QFileDialog::getOpenFileName(this, tr("Open File"), "", tr("JPEG (*.jpg *.jpeg);; PNG (*.png)"));

    // Load image into QImage variable and extract dimensions
    origImage->load(imagePath);
    origWidth = origImage->width();
    origHeigth = origImage->height();

    // Update UI
    ui->label_imagePath->clear();
    ui->label_imagePath->setText(imagePath + " [" + QString::number(origWidth) + "x" + QString::number(origHeigth) + "]");
    ui->spinBox_x->setMaximum(origWidth);
    ui->spinBox_x->setValue(origWidth);
    ui->spinBox_y->setValue(origHeigth);

    // Load new image in UI panel
    *origPix = QPixmap::fromImage(*origImage);
    origScene->clear();
    origScene->addPixmap(*origPix);
    origScene->setSceneRect(origPix->rect());
    ui->graphicsView_orig->show();

    // Enable the resize button
    ui->pushButton_doResize->setEnabled(1);
}

// Slot which captures the resize pushbutton
void MainWindow::doProcResize()
{
    // Indicate processing start
    ui->pushButton_doResize->setEnabled(0);
    ui->pushButton_doResize->setText("Processing...");
    qApp->processEvents(); // Force ui update

    modWidth = ui->spinBox_x->value();

    // Resize image without seam carving
    //free(resizeImage);
    *resizeImage = origImage->scaled(modWidth, origHeigth, Qt::IgnoreAspectRatio);
    *resizePix = QPixmap::fromImage(*resizeImage);
    resizeScene->clear();
    resizeScene->addPixmap(*resizePix);
    resizeScene->setSceneRect(resizePix->rect());
    ui->graphicsView_resize->show();

    if (ui->radioButton_algSerial->isChecked()) // Serial processing
    {
        // Start timer
        ui->textBrowser_console->append("\n--\nStarting serial processing.");
        timer.start();

        // Run the hurdles
        serialGenBrightness();
        serialGenEnergy();
        serialGenPath();
        serialGenMask();
        serialGenMod();

        // Output total time spent (plus preemption apparently)
        ui->textBrowser_console->append("Finished processing at: " +
                                        QString::number(timer.nsecsElapsed()) + "ns." +
                                        " (" + QString::number(timer.nsecsElapsed()/1000000) + " ms)");
        //qDebug() << "Took: " << timer.nsecsElapsed() << " nsecs.";
    }
    else if (ui->radioButton_algOmp->isChecked()) // OMP processing
    {
        // Get number of threads
        threadCount = ui->spinBox_threads->value();

        // Start timer
        ui->textBrowser_console->append("\n--\nStarting OMP processing.");
        timer.start();

        // Run the hurdles
        ompGenBrightness();
        ompGenEnergy();
        ompGenPath();
        ompGenMask();
        ompGenMod();

        // Output total time spent (plus preemption apparently)
        ui->textBrowser_console->append("Finished processing at: " +
                                        QString::number(timer.nsecsElapsed()) + "ns. (" +
                                        QString::number(timer.nsecsElapsed()/1000000) + " ms)");
    }
    else if (ui->radioButton_algPthreads->isChecked()) // pThreads processing
    {
        // Get number of threads
        threadCount = ui->spinBox_threads->value();

        // Start timer
        ui->textBrowser_console->append("\n--\nStarting [" + QString::number(threadCount) + "] pThread processing.");
        timer.start();

        // Set up for threads
        thread_handles = (pthread_t*)malloc(threadCount * sizeof(pthread_t));
        threadRankAssign = 0;
        if (pthread_mutex_init(&mutex, NULL))
        {
            qDebug() << "Error in pthread mutex init.";
        }
        if (pthread_barrier_init(&barrier, NULL, threadCount))
        {
            qDebug() << "Error in pthread barrier creation.";
        }

        // Run the hurdles
        for (thread = 0; thread < threadCount; thread++)
        {
            if (pthread_create(&thread_handles[thread], NULL, &MainWindow::pthreadBootstrap, this))
            {
                qDebug() << "Error creating pthreads.";
            }
        }

        for (thread = 0; thread < threadCount; thread++)
        {
            if (pthread_join(thread_handles[thread], NULL))
            {
                qDebug() << "Error joining pthreads.";
            }
        }

        // Clean up for threads
        free(thread_handles);

        // Output total time spent (plus preemption apparently)
        ui->textBrowser_console->append("Finished processing at: " +
                                        QString::number(timer.nsecsElapsed()) + "ns. (" +
                                        QString::number(timer.nsecsElapsed()/1000000) + " ms)");
    }

    *energyPix = QPixmap::fromImage(*energyImage);
    energyScene->clear();
    energyScene->addPixmap(*energyPix);
    energyScene->setSceneRect(energyPix->rect());
    ui->graphicsView_energy->show();

    *modPix = QPixmap::fromImage(*modImage);
    modScene->clear();
    modScene->addPixmap(*modPix);
    modScene->setSceneRect(modPix->rect());
    ui->graphicsView_mod->show();

    // Save modified files to disk
    resizeImage->save((imagePath+"-resize.jpg"), 0, 100);
    energyImage->save((imagePath+"-energy.jpg"), 0, 100);
    modImage->save((imagePath+"-mod.jpg"), 0, 100);

    // Indicate processing end
    ui->pushButton_doResize->setEnabled(1);
    ui->pushButton_doResize->setText("Process Resize");
}

void MainWindow::doHandleRadioSerial()
{
    if (ui->radioButton_algSerial->isChecked())
    {
        ui->radioButton_algOmp->setChecked(0);
        ui->radioButton_algPthreads->setChecked(0);
    }
}

void MainWindow::doHandleRadioOmp()
{
    if (ui->radioButton_algOmp->isChecked())
    {
        ui->radioButton_algSerial->setChecked(0);
        ui->radioButton_algPthreads->setChecked(0);
    }
}

void MainWindow::doHandleRadioPthreads()
{
    if (ui->radioButton_algPthreads->isChecked())
    {
        ui->radioButton_algOmp->setChecked(0);
        ui->radioButton_algSerial->setChecked(0);
    }
}

int MainWindow::getBrightness(int x, int y)
{
    // Variables
    int index;

    // Check for out-of-bounds
    if (x < 0 || x >= origWidth || y < 0 || y >= origHeigth)
    {
        return 0;
    }

    // Calculate the index
    index = (x*origHeigth)+y;

    // Check for erroneous index
    if (index >= brightnessGrid.count())
    {
        qDebug() << "get: index out of range for brightness!";
        qDebug() << "Last indecies: " << x << ", " << y << ". Index: " << index;
        qDebug() << "Size of brightness: " << brightnessGrid.count();
        exit(-1);
    }

    // Return brightness from actual pixel
    return (brightnessGrid[index]);
}

void MainWindow::setBrightness(int x, int y, int value)
{
    // Variables
    int index;

    // Check for out-of-bounds
    if (x < 0 || x > origWidth || y < 0 || y > origHeigth)
    {
        qDebug() << "Tried to set bad x/y value for brightness!";
        exit(-1);
    }

    // Calculate the index
    index = (x*origHeigth)+y;

    // Check for erroneous index
    if (index >= brightnessGrid.count())
    {
        qDebug() << "set: index out of range for brightness!";
        exit(-1);
    }

    // Return brightness from actual pixel
    brightnessGrid[index] = value;
}

int MainWindow::getEnergy(int x, int y)
{
    // Variables
    int index;

    // Check for out-of-bounds
    if (x < 0 || x >= origWidth || y < 0 || y >= origHeigth)
    {
        return 0;
    }

    // Calculate the index
    index = (x*origHeigth)+y;

    // Check for erroneous index
    if (index >= energyGrid.count())
    {
        qDebug() << "get: index out of range for energyGrid!";
        qDebug() << "Last indecies: " << x << ", " << y << ". Index: " << index;
        qDebug() << "Size of brightness: " << energyGrid.count();
        exit(-1);
    }

    // Return brightness from actual pixel
    return (energyGrid[index]);
}

void MainWindow::setEnergy(int x, int y, int value)
{
    // Variables
    int index;

    // Check for out-of-bounds
    if (x < 0 || x > origWidth || y < 0 || y > origHeigth)
    {
        qDebug() << "Tried to set bad x/y value for energyGrid!";
        exit(-1);
    }

    // Calculate the index
    index = (x*origHeigth)+y;

    // Check for erroneous index
    if (index >= energyGrid.count())
    {
        qDebug() << "set: index out of range for energyGrid!";
        exit(-1);
    }

    // Return brightness from actual pixel
    energyGrid[index] = value;
}

int MainWindow::getPath(int x, int y)
{
    // Variables
    int index;

    // Check for out-of-bounds
    if (x < 0 || x >= origWidth || y < 0 || y >= origHeigth)
    {
        return 0;
    }

    // Calculate the index
    index = (x*origHeigth)+y;

    // Check for erroneous index
    if (index >= pathGrid.count())
    {
        qDebug() << "get: index out of range for pathGrid!";
        qDebug() << "Last indecies: " << x << ", " << y << ". Index: " << index;
        qDebug() << "Size of brightness: " << pathGrid.count();
        exit(-1);
    }

    // Return brightness from actual pixel
    return (pathGrid[index]);
}

void MainWindow::setPath(int x, int y, int value)
{
    // Variables
    int index;

    // Check for out-of-bounds
    if (x < 0 || x > origWidth || y < 0 || y > origHeigth)
    {
        qDebug() << "Tried to set bad x/y value for pathGrid!";
        exit(-1);
    }

    // Calculate the index
    index = (x*origHeigth)+y;

    // Check for erroneous index
    if (index >= pathGrid.count())
    {
        qDebug() << "set: index out of range for pathGrid!";
        qDebug() << "Pathgrid size: " << pathGrid.count();
        exit(-1);
    }

    // Return brightness from actual pixel
    pathGrid[index] = value;
}

bool MainWindow::getMask(int x, int y)
{
    // Variables
    int index;

    // Check for out-of-bounds
    if (x < 0 || x >= origWidth || y < 0 || y >= origHeigth)
    {
        return 1;
    }

    // Calculate the index
    index = (x*origHeigth)+y;

    // Check for erroneous index
    if (index >= maskGrid.count())
    {
        qDebug() << "get: index out of range for maskGrid!";
        qDebug() << "Last indecies: " << x << ", " << y << ". Index: " << index;
        qDebug() << "Size of brightness: " << maskGrid.count();
        exit(-1);
    }

    // Return brightness from actual pixel
    return (maskGrid[index]);
}

void MainWindow::setMask(int x, int y, bool value)
{
    // Variables
    int index;

    // Check for out-of-bounds
    if (x < 0 || x > origWidth || y < 0 || y > origHeigth)
    {
        qDebug() << "Tried to set bad x/y value for maskGrid!";
        exit(-1);
    }

    // Calculate the index
    index = (x*origHeigth)+y;

    // Check for erroneous index
    if (index >= maskGrid.count())
    {
        qDebug() << "set: index out of range for maskGrid!";
        exit(-1);
    }

    // Return brightness from actual pixel
    maskGrid[index] = value;
}

int MainWindow::getLowestPathIndex(int startX, int endX)
{
    int x, y, low, lowIndex;

    y = origHeigth-1;
    low = getEnergy(startX, y);
    while (getMask(startX, y))
    {
        startX++;
    }
    lowIndex = startX;

    for (x = startX+1; x <= endX; x++)
    {
        if (low > getEnergy(x, y) && !getMask(x, y))
        {
            low = getEnergy(x, y);
            lowIndex = x;
        }
    }
    return(lowIndex);
}

int MainWindow::getNearestLateral(int x, int y)
{
    int dist = 0;

    while (1)
    {
        // Check left
        if (!getMask(x-dist, y))
            return x-dist;
        // Check right
        if (!getMask(x+dist, y))
            return x+dist;
        dist++;
    }
}

void MainWindow::serialGenBrightness()
{
    // Variables
    int r, g, b, total;
    brightnessGrid.clear();

    // Instantiation
    brightnessGrid.resize(origWidth * origHeigth);

    // Process
    for (int x = 0; x < origWidth; x++)
    {
        for (int y = 0; y < origHeigth; y++)
        {
            QColor::fromRgb(origImage->pixel(x, y)).toRgb().getRgb(&r, &g, &b);
            total = (r + g + b) / 3;
            setBrightness(x, y, total);
        }
    }
    //qDebug() << "Image size: " << image->width() << " x " << image->height() << ". Count: " << (image->width() * image->height());
    //qDebug() << "brightness size: " << brightness->size();
}

void MainWindow::serialGenEnergy()
{
    // Variables
    int energy, energyx, energyy, a, b, c, d, f, g, h, i, energyPixel;

    // Instantiation
    energyGrid.clear();
    energyGrid.resize(origWidth * origHeigth);

    if (energyImage != NULL)
    {
        delete energyImage;
        energyImage = new QImage(origWidth, origHeigth, QImage::Format_RGB32);
    }

    for (int x = 0; x < origWidth; x++)
    {
        for (int y = 0; y < origHeigth; y++)
        {
            a = getBrightness(x-1, y-1);
            b = getBrightness(x,   y-1);
            c = getBrightness(x+1, y-1);
            d = getBrightness(x-1, y);
            f = getBrightness(x+1, y);
            g = getBrightness(x-1, y+1);
            h = getBrightness(x,   y+1);
            i = getBrightness(x+1, y+1);

            energyx = a + (2*d) + g - c - (2*f) - i;
            energyy = a + (2*b) + c - g - (2*h) - i;
            energy = sqrt((energyx * energyx) + (energyy * energyy));
            energyPixel = abs(energy);
            if (energyPixel > 255)
                energyPixel = 255;
            setEnergy(x, y, energy);
            energyImage->setPixel(x, y, QColor::fromRgb(energyPixel, energyPixel, energyPixel).rgb());
        }
    }
}

void MainWindow::serialGenPath()
{
    int left, middle, right, energy;
    int x, y;

    // Instantiation
    pathGrid.clear();
    pathGrid.resize(origWidth * origHeigth);

    for (y = 0; y < origHeigth; y++)
    {
        // Handle case where left is off-image
        x = 0;
        middle = getPath(x, y-1);
        right = getPath(x+1, y-1);
        energy = getEnergy(x, y);
        if (right < left && right < middle)
        {
            setPath(x, y, (right + energy));
        }
        else
        {
            setPath(x, y, (middle + energy));
        }

        // Handle common case
        for (x = 1; x < origWidth-1; x++)
        {
            left = getPath(x-1, y-1);
            middle = getPath(x, y-1);
            right = getPath(x+1, y-1);
            energy = getEnergy(x, y);
            if (left < middle && left < right)
            {
                setPath(x, y, (left + energy));
            }
            else if (right < left && right < middle)
            {
                setPath(x, y, (right + energy));
            }
            else
            {
                setPath(x, y, (middle + energy));
            }
        }

        // Handle case where x is on right side
        x = origImage->width()-1;
        left = getPath(x-1, y-1);
        middle = getPath(x, y-1);
        energy = getEnergy(x, y);
        if (left < middle && left < right)
        {
            setPath(x, y, (left + energy));
        }
        else
        {
            setPath(x, y, (middle + energy));
        }
    }

//    QByteArray text;
//    for (int y = 0; y < 50 /*origImage->height()*/; y++)
//    {
//        text.clear();
//        for (int x = 0; x < 5 /*origImage->width()*/; x++)
//        {
//            text += QByteArray::number(getPath(x,y));
//            text += ',';
//            text += ' ';
//        }
//        text += " : ";
//        for (int x = 0; x < 5 /*origImage->width()*/; x++)
//        {
//            text += QByteArray::number(getEnergy(x,y));
//            text += ',';
//            text += ' ';
//        }
//        text += '\n';
//        ui->textBrowser_console->append(text);
//    }
}

void MainWindow::serialGenMask()
{
    // Variables
    int seamCount, y, pathX;
    int left, middle, right;

    // Instantiation
    maskGrid.clear();
    maskGrid.resize(origWidth * origHeigth);

//    for (x = 0; x < origImage->width(); x++)
//    {
//        for (y = 0; y < origImage->height(); y++)
//        {
//            //
//        }
//    }

    for (seamCount = 0; seamCount < (origWidth - modWidth); seamCount++)
    {
        pathX = getLowestPathIndex(0, origWidth-1);
        for (y = origHeigth-1; y >0; y--)
        {
            setMask(pathX, y, 1);
            middle = getPath(pathX, y-1);
            if (pathX == 0)
            {
                // edge case left
                right = getPath(pathX+1, y-1);
                if (right < middle)
                {
                    pathX = getNearestLateral(pathX+1, y-1);
                }
                else
                {
                    pathX = getNearestLateral(pathX, y-1);
                }
            }
            else if (pathX == origImage->width()-1)
            {
                // edge case right
                left = getPath(pathX-1, y-1);
                if (left < middle)
                {
                    pathX = getNearestLateral(pathX-1, y-1);
                }
                else
                {
                    pathX = getNearestLateral(pathX, y-1);
                }
            }
            else
            {
                // common case
                left = getPath(pathX-1, y-1);
                right = getPath(pathX+1, y-1);
                if (left < middle && left < right)
                {
                    pathX = getNearestLateral(pathX-1, y-1);
                }
                else if (right < middle && right < left)
                {
                    pathX = getNearestLateral(pathX+1, y-1);
                }
                else
                {
                    pathX = getNearestLateral(pathX, y-1);
                }
            }
        }
        setMask(pathX, y, 1);
    }

    for (int x = 0; x < origWidth; x++)
    {
        for (int y = 0; y < origHeigth; y++)
        {
            if (getMask(x, y))
                energyImage->setPixel(x, y, QColor::fromRgb(150, 0, 150).rgb());
        }
    }
}

void MainWindow::serialGenMod()
{
    int x, modX, y;

    if (modImage != NULL)
    {
        free(modImage);
        modImage = new QImage(modWidth, origHeigth, QImage::Format_RGB32);
    }

    for (y = 0; y < origHeigth; y++)
    {
        modX = 0;
        for (x = 0; x < origWidth; x++)
        {
            if (getMask(x, y))
            {
                continue;
            }
            if (modX >= modWidth)
                qDebug() << "problem";
            modImage->setPixel(modX, y, origImage->pixel(x, y));
            modX++;
        }
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// OMP
///////////////////////////////////////////////////////////////////////////////////////////////////////////////



void MainWindow::ompGenBrightness()
{
    // Variables
    int r, g, b, total;
    brightnessGrid.clear();

    // Instantiation
    brightnessGrid.resize(origWidth * origHeigth);

    // Process
#pragma omp parallel for num_threads(threadCount)
    for (int x = 0; x < origWidth; x++)
    {
        for (int y = 0; y < origHeigth; y++)
        {
            QColor::fromRgb(origImage->pixel(x, y)).toRgb().getRgb(&r, &g, &b);
            total = (r + g + b) / 3;
            setBrightness(x, y, total);
        }
    }
    //qDebug() << "Image size: " << image->width() << " x " << image->height() << ". Count: " << (image->width() * image->height());
    //qDebug() << "brightness size: " << brightness->size();
}

void MainWindow::ompGenEnergy()
{
    // Instantiation
    energyGrid.clear();
    energyGrid.resize(origWidth * origHeigth);

    if (energyImage != NULL)
    {
        delete energyImage;
        energyImage = new QImage(origWidth, origHeigth, QImage::Format_RGB32);
    }

    #pragma omp parallel for num_threads(threadCount)
    for (int x = 0; x < origWidth; x++)
    {
        // I'm glad we went over this in class, I spent way too long wondering why values weren't right,
        // when it was because each thread was sharing them.
        int energy, energyx, energyy, a, b, c, d, f, g, h, i, pixelEnergy;
        for (int y = 0; y < origHeigth; y++)
        {
            a = getBrightness(x-1, y-1);
            b = getBrightness(x,   y-1);
            c = getBrightness(x+1, y-1);
            d = getBrightness(x-1, y);
            f = getBrightness(x+1, y);
            g = getBrightness(x-1, y+1);
            h = getBrightness(x,   y+1);
            i = getBrightness(x+1, y+1);

            energyx = a + (2*d) + g - c - (2*f) - i;
            energyy = a + (2*b) + c - g - (2*h) - i;
            energy = sqrt((energyx * energyx) + (energyy * energyy));

            setEnergy(x, y, energy);
            pixelEnergy = abs(energy);
            if (pixelEnergy > 255)
                pixelEnergy = 255;
            energyImage->setPixel(x, y, QColor::fromRgb(pixelEnergy, pixelEnergy, pixelEnergy).rgb());
//#pragma omp critical
            //ui->textBrowser_console->append(", " + QString::number(energy));
        }
    }
}

void MainWindow::ompGenPath()
{
    // Instantiation
    pathGrid.clear();
    pathGrid.resize(origWidth * origHeigth);

#pragma omp parallel for num_threads(threadCount)
    for (int y = 0; y < origHeigth; y++)
    {
        int left, middle, right, energy;
        int x;

        // Handle case where left is off-image
        x = 0;
        middle = getPath(x, y-1);
        right = getPath(x+1, y-1);
        energy = getEnergy(x, y);
        if (right < left && right < middle)
        {
#pragma     omp critical
            setPath(x, y, (right + energy));
        }
        else
        {
#pragma     omp critical
            setPath(x, y, (middle + energy));
        }

        // Handle common case
        for (x = 1; x < origWidth-1; x++)
        {
            left = getPath(x-1, y-1);
            middle = getPath(x, y-1);
            right = getPath(x+1, y-1);
            energy = getEnergy(x, y);
            if (left < middle && left < right)
            {
#pragma         omp critical
                setPath(x, y, (left + energy));
            }
            else if (right < left && right < middle)
            {
#pragma         omp critical
                setPath(x, y, (right + energy));
            }
            else
            {
#pragma         omp critical
                setPath(x, y, (middle + energy));
            }
        }

        // Handle case where x is on right side
        //x = origWidth-1;
        left = getPath(x-1, y-1);
        middle = getPath(x, y-1);
        energy = getEnergy(x, y);
        if (left < middle && left < right)
        {
#pragma     omp critical
            setPath(x, y, (left + energy));
        }
        else
        {
#pragma     omp critical
            setPath(x, y, (middle + energy));
        }
    }

//    QByteArray text;
//    for (int y = 0; y < 50 /*origImage->height()*/; y++)
//    {
//        text.clear();
//        for (int x = 0; x < 5 /*origImage->width()*/; x++)
//        {
//            text += QByteArray::number(getPath(x,y));
//            text += ',';
//            text += ' ';
//        }
//        text += " : ";
//        for (int x = 0; x < 5 /*origImage->width()*/; x++)
//        {
//            text += QByteArray::number(getEnergy(x,y));
//            text += ',';
//            text += ' ';
//        }
//        text += '\n';
//        ui->textBrowser_console->append(text);
//    }
}

void MainWindow::ompGenMask()
{
    // Variables
//    int seamCount, y, pathX;
//    int left, middle, right;

    // Instantiation
    maskGrid.clear();
    maskGrid.resize(origWidth * origHeigth);

//    for (x = 0; x < origImage->width(); x++)
//    {
//        for (y = 0; y < origImage->height(); y++)
//        {
//            //
//        }
//    }

#pragma omp parallel for num_threads(threadCount)
    for (int seamCount = 0; seamCount < (origWidth - modWidth); seamCount++)
    {
        int y, pathX;
        int left, middle, right;

#pragma omp critical
        {
            pathX = getLowestPathIndex(0, origWidth-1);
            setMask(pathX, (origHeigth-1), 1);
        }
        for (y = origHeigth-1; y > 0; y--)
        {
#pragma     omp critical
            setMask(pathX, y, 1);
            middle = getPath(pathX, y-1);
            if (pathX == 0)
            {
                // edge case left
                right = getPath(pathX+1, y-1);
                if (right < middle)
                {
#pragma omp critical
                    pathX = getNearestLateral(pathX+1, y-1);
                }
                else
                {
                    #pragma omp critical
                    pathX = getNearestLateral(pathX, y-1);
                }
            }
            else if (pathX == origWidth-1)
            {
                // edge case right
                left = getPath(pathX-1, y-1);
                if (left < middle)
                {
                    #pragma omp critical
                    pathX = getNearestLateral(pathX-1, y-1);
                }
                else
                {
                    #pragma omp critical
                    pathX = getNearestLateral(pathX, y-1);
                }
            }
            else
            {
                // common case
                left = getPath(pathX-1, y-1);
                right = getPath(pathX+1, y-1);
                if (left < middle && left < right)
                {
                    #pragma omp critical
                    pathX = getNearestLateral(pathX-1, y-1);
                }
                else if (right < middle && right < left)
                {
                    #pragma omp critical
                    pathX = getNearestLateral(pathX+1, y-1);
                }
                else
                {
                    #pragma omp critical
                    pathX = getNearestLateral(pathX, y-1);
                }
            }
        }
#pragma omp critical
        setMask(pathX, y, 1);
    }

#pragma omp parallel for num_threads(threadCount)
    for (int x = 0; x < origWidth; x++)
    {
        for (int y = 0; y < origHeigth; y++)
        {
            if (getMask(x, y))
                energyImage->setPixel(x, y, QColor::fromRgb(150, 0, 150, 150).rgb());
        }
    }

    int counter = 0;
    for (int x = 0; x < origImage->width(); x++)
    {
        if (getMask(x,795))
            counter++;
    }
    ui->textBrowser_console->append("Data: "+QString::number(counter));
}

void MainWindow::ompGenMod()
{
    if (modImage != NULL)
    {
        free(modImage);
        modImage = new QImage(modWidth, origHeigth, QImage::Format_RGB32);
    }

#pragma omp parallel for num_threads(threadCount)
    for (int y = 0; y < origHeigth; y++)
    {
        int x, modX;
        modX = 0;
        for (x = 0; x < origWidth; x++)
        {
            if (getMask(x, y))
            {
                continue;
            }
            if (modX >= modWidth)
            {
                //qDebug() << "problem";
                break;
            }
            modImage->setPixel(modX, y, origImage->pixel(x, y));
            modX++;
        }
    }
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PTHREAD
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


void * MainWindow::pthreadBootstrap(void * arg)
{
    return ((MainWindow *)arg)->pthreadManager();
}

void * MainWindow::pthreadManager()
{
//    long * my_rank = (long*) rank;
    int rank = 0;
    int rc;

    pthread_mutex_lock(&mutex);
    rank = threadRankAssign;
    //qDebug() << "Hello from rank " << rank;
    threadRankAssign++;
    pthread_mutex_unlock(&mutex);

    if (rank == 0)
    {
        brightnessGrid.clear();
        brightnessGrid.resize(origWidth * origHeigth);
        energyGrid.clear();
        energyGrid.resize(origWidth * origHeigth);
        pathGrid.clear();
        pathGrid.resize(origWidth * origHeigth);
        maskGrid.clear();
        maskGrid.resize(origWidth * origHeigth);
        if (energyImage != NULL)
        {
            delete energyImage;
            energyImage = new QImage(origWidth, origHeigth, QImage::Format_RGB32);
        }
        if (modImage != NULL)
        {
            free(modImage);
            modImage = new QImage(modWidth, origHeigth, QImage::Format_RGB32);
        }
    }

    rc = pthread_barrier_wait(&barrier);
    if (rc != 0 && rc != PTHREAD_BARRIER_SERIAL_THREAD)
    {
        qDebug() << "Error: rank " << QString::number(rank) << " issue with barrier.";
    }
    pthreadGenBrightness(rank);

    rc = pthread_barrier_wait(&barrier);
    if (rc != 0 && rc != PTHREAD_BARRIER_SERIAL_THREAD)
    {
        qDebug() << "Error: rank " << QString::number(rank) << " issue with barrier.";
    }
    pthreadGenEnergy(rank);

    rc = pthread_barrier_wait(&barrier);
    if (rc != 0 && rc != PTHREAD_BARRIER_SERIAL_THREAD)
    {
        qDebug() << "Error: rank " << QString::number(rank) << " issue with barrier.";
    }
    pthreadGenPath(rank);

    rc = pthread_barrier_wait(&barrier);
    if (rc != 0 && rc != PTHREAD_BARRIER_SERIAL_THREAD)
    {
        qDebug() << "Error: rank " << QString::number(rank) << " issue with barrier.";
    }
    pthreadGenMask(rank);

    rc = pthread_barrier_wait(&barrier);
    if (rc != 0 && rc != PTHREAD_BARRIER_SERIAL_THREAD)
    {
        qDebug() << "Error: rank " << QString::number(rank) << " issue with barrier.";
    }
    pthreadGenMod(rank);

    if (rank == 0)
    {
//        serialGenPath();
//        serialGenMask();
//        serialGenMod();
    }

    return(NULL);
}

void MainWindow::pthreadGenBrightness(int rank)
{
    // Variables
    int r, g, b, total;
    int xStart, xSlice;

    xSlice = (origWidth / threadCount);
    xStart = (xSlice * (rank));
    if (rank == (threadCount-1))
    {
        xSlice = origWidth-xStart;
    }

    // Process
    for (int x = xStart; x < (xStart+xSlice); x++)
    {
        for (int y = 0; y < origHeigth; y++)
        {
            QColor::fromRgb(origImage->pixel(x, y)).toRgb().getRgb(&r, &g, &b);
            total = (r + g + b) / 3;
            pthread_mutex_lock(&mutex);
            setBrightness(x, y, total);
            pthread_mutex_unlock(&mutex);
        }
    }
}

void MainWindow::pthreadGenEnergy(int rank)
{
    // Variables
    int energy, energyx, energyy, a, b, c, d, f, g, h, i;
    int xStart, xSlice;
    int energyPixel;

    xSlice = (origWidth / threadCount);
    xStart = (xSlice * (rank));
    if (rank == (threadCount-1))
    {
        xSlice = origWidth-xStart;
    }



    for (int x = xStart; x < (xStart+xSlice); x++)
    {
        for (int y = 0; y < origHeigth; y++)
        {
            a = getBrightness(x-1, y-1);
            b = getBrightness(x,   y-1);
            c = getBrightness(x+1, y-1);
            d = getBrightness(x-1, y);
            f = getBrightness(x+1, y);
            g = getBrightness(x-1, y+1);
            h = getBrightness(x,   y+1);
            i = getBrightness(x+1, y+1);

            energyx = a + (2*d) + g - c - (2*f) - i;
            energyy = a + (2*b) + c - g - (2*h) - i;
            energy = sqrt((energyx * energyx) + (energyy * energyy));

            pthread_mutex_lock(&mutex);
            setEnergy(x, y, energy);
            energyPixel = abs(energy);
            if (energyPixel > 255)
                energyPixel = 255;
            energyImage->setPixel(x, y, QColor::fromRgb(energyPixel, energyPixel, energyPixel).rgb());
            pthread_mutex_unlock(&mutex);
        }
    }
}

void MainWindow::pthreadGenPath(int rank)
{
    int left, middle, right, energy;
    int x, y;
    int xStart, xSlice;

    xSlice = (origWidth / threadCount);
    xStart = (xSlice * (rank));
    if (rank == (threadCount-1))
    {
        xSlice = origWidth-xStart;
    }

    for (y = 0; y < origHeigth; y++)
    {
        for (x = xStart; x < (xStart+xSlice); x++)
        {
            if (x == 0) // Handle case where left is off-image
            {
                middle = getPath(x, y-1);
                right = getPath(x+1, y-1);
                energy = getEnergy(x, y);
                if (right < left && right < middle)
                {
                    setPath(x, y, (right + energy));
                }
                else
                {
                    setPath(x, y, (middle + energy));
                }
            }
            else if (x == origWidth) // Handle case where x is on right side
            {
                left = getPath(x-1, y-1);
                middle = getPath(x, y-1);
                energy = getEnergy(x, y);
                if (left < middle && left < right)
                {
                    setPath(x, y, (left + energy));
                }
                else
                {
                    setPath(x, y, (middle + energy));
                }
            }
            else
            {
                left = getPath(x-1, y-1);
                middle = getPath(x, y-1);
                right = getPath(x+1, y-1);
                energy = getEnergy(x, y);
                if (left < middle && left < right)
                {
                    setPath(x, y, (left + energy));
                }
                else if (right < left && right < middle)
                {
                    setPath(x, y, (right + energy));
                }
                else
                {
                    setPath(x, y, (middle + energy));
                }
            }
        }
    }

//    QByteArray text;
//    for (int y = 0; y < 50 /*origImage->height()*/; y++)
//    {
//        text.clear();
//        for (int x = 0; x < 5 /*origImage->width()*/; x++)
//        {
//            text += QByteArray::number(getPath(x,y));
//            text += ',';
//            text += ' ';
//        }
//        text += " : ";
//        for (int x = 0; x < 5 /*origImage->width()*/; x++)
//        {
//            text += QByteArray::number(getEnergy(x,y));
//            text += ',';
//            text += ' ';
//        }
//        text += '\n';
//        ui->textBrowser_console->append(text);
//    }
}

void MainWindow::pthreadGenMask(int rank)
{
    // Variables
    int seamCount, y, pathX;
    int left, middle, right;
    int seamTarget;

    seamTarget = (origWidth - modWidth) / threadCount;
    if (rank == (threadCount-1))
    {
        seamTarget = (origWidth - modWidth) - (seamTarget * rank);
    }

    for (seamCount = 0; seamCount < seamTarget; seamCount++)
    {
        pthread_mutex_lock(&mutex);
        pathX = getLowestPathIndex(0, origWidth-1);
        setMask(pathX, y, 1);
        pthread_mutex_unlock(&mutex);
        for (y = origHeigth-1; y >0; y--)
        {
            setMask(pathX, y, 1);
            middle = getPath(pathX, y-1);
            if (pathX == 0)
            {
                // edge case left
                right = getPath(pathX+1, y-1);
                if (right < middle)
                {
                    pathX = getNearestLateral(pathX+1, y-1);
                }
                else
                {
                    pathX = getNearestLateral(pathX, y-1);
                }
            }
            else if (pathX == origImage->width()-1)
            {
                // edge case right
                left = getPath(pathX-1, y-1);
                if (left < middle)
                {
                    pathX = getNearestLateral(pathX-1, y-1);
                }
                else
                {
                    pathX = getNearestLateral(pathX, y-1);
                }
            }
            else
            {
                // common case
                left = getPath(pathX-1, y-1);
                right = getPath(pathX+1, y-1);
                if (left < middle && left < right)
                {
                    pathX = getNearestLateral(pathX-1, y-1);
                }
                else if (right < middle && right < left)
                {
                    pathX = getNearestLateral(pathX+1, y-1);
                }
                else
                {
                    pathX = getNearestLateral(pathX, y-1);
                }
            }
        }
        setMask(pathX, y, 1);
    }

    for (int x = 0; x < origWidth; x++)
    {
        for (int y = 0; y < origHeigth; y++)
        {
            if (getMask(x, y))
                energyImage->setPixel(x, y, QColor::fromRgb(150, 0, 150).rgb());
        }
    }
}

void MainWindow::pthreadGenMod(int rank)
{
    int x, modX, y;
    int yStart, ySlice;

    ySlice = (origHeigth / threadCount);
    yStart = (ySlice * (rank));
    if (rank == (threadCount-1))
    {
        ySlice = origHeigth-yStart-1;
    }

    for (y = yStart; y < (yStart+ySlice); y++)
    {
        modX = 0;
        for (x = 0; x < origWidth; x++)
        {
            if (getMask(x, y))
            {
                continue;
            }
            if (modX >= modWidth)
                qDebug() << "problem";
            modImage->setPixel(modX, y, origImage->pixel(x, y));
            modX++;
        }
    }
}













