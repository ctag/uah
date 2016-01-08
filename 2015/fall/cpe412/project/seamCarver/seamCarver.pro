#-------------------------------------------------
#
# Project created by QtCreator 2015-12-08T19:30:28
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = seamCarver
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp

HEADERS  += mainwindow.h

FORMS    += mainwindow.ui

QMAKE_CXXFLAGS += -fopenmp -pthread -O3
LIBS += -fopenmp -pthread
