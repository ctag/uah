/*************************************************************************
 *
 * Copyright (c) 2012 Digia Plc.
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

#ifndef QUOTEBUTTON_H
#define QUOTEBUTTON_H

#include <QPushButton>
#include <QStringList>

class QuoteButton: public QPushButton
{
    Q_OBJECT

public:
    QuoteButton(const QString &text, QWidget *parent = 0);

signals:
    void quote(const QString &);

protected slots:
    void sendQuote();

private:
    int m_quoteNo;
    QStringList m_quotes;
};

#endif // QUOTEBUTTON_H
