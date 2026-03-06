#ifndef SYNTAXHIGHLIGHTER_H
#define SYNTAXHIGHLIGHTER_H

#include <QSyntaxHighlighter>
#include <QTextCharFormat>
#include <QRegularExpression>
#include <QQuickTextDocument>
#include <QQmlEngine>

class SyntaxHighlighter : public QSyntaxHighlighter
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QQuickTextDocument* document READ quickDocument WRITE setQuickDocument NOTIFY documentChanged)
    Q_PROPERTY(QString fileExtension READ fileExtension WRITE setFileExtension NOTIFY fileExtensionChanged)

public:
    explicit SyntaxHighlighter(QObject *parent = nullptr);

    QQuickTextDocument* quickDocument() const { return m_quickDocument; }
    void setQuickDocument(QQuickTextDocument *doc);

    QString fileExtension() const { return m_fileExtension; }
    void setFileExtension(const QString &ext);

signals:
    void documentChanged();
    void fileExtensionChanged();

protected:
    void highlightBlock(const QString &text) override;

private:
    struct HighlightRule {
        QRegularExpression pattern;
        QTextCharFormat format;
    };

    void setupRules();
    void setupCppRules();
    void setupJsRules();
    void setupPythonRules();
    void setupQmlRules();
    void setupGenericRules();

    QQuickTextDocument *m_quickDocument = nullptr;
    QString m_fileExtension;
    QVector<HighlightRule> m_rules;
    QTextCharFormat m_multiLineCommentFormat;
    QRegularExpression m_commentStartExpression;
    QRegularExpression m_commentEndExpression;
};

#endif // SYNTAXHIGHLIGHTER_H
