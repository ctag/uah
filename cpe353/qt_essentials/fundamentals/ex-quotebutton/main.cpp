/*************************************************************************
 *
 * Copyright (c) 2012 Digia Plc.
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

#include <QtWidgets>
#include "quotebutton.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QWidget *top = new QWidget;
    top->setWindowTitle("Quotes from Office Space");

    QuoteButton* button = new QuoteButton("Quote", top);
    QTextEdit* edit = new QTextEdit(top);
    QObject::connect(
        button, SIGNAL(quote(const QString &)),
        edit, SLOT(setText(const QString &))
    );

    QVBoxLayout *layout = new QVBoxLayout;
    layout->addWidget(button);
    layout->addWidget(edit);
    top->setLayout(layout);
    top->show();

    return app.exec();
}
