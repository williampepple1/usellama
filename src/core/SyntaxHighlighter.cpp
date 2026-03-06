#include "SyntaxHighlighter.h"
#include <QFileInfo>

SyntaxHighlighter::SyntaxHighlighter(QObject *parent)
    : QSyntaxHighlighter(parent)
{
    setupGenericRules();
}

void SyntaxHighlighter::setQuickDocument(QQuickTextDocument *doc)
{
    if (m_quickDocument != doc) {
        m_quickDocument = doc;
        if (doc)
            setDocument(doc->textDocument());
        emit documentChanged();
    }
}

void SyntaxHighlighter::setFileExtension(const QString &ext)
{
    if (m_fileExtension != ext) {
        m_fileExtension = ext.toLower();
        setupRules();
        emit fileExtensionChanged();
        rehighlight();
    }
}

void SyntaxHighlighter::setupRules()
{
    m_rules.clear();
    if (m_fileExtension == "cpp" || m_fileExtension == "h" ||
        m_fileExtension == "c" || m_fileExtension == "hpp") {
        setupCppRules();
    } else if (m_fileExtension == "js" || m_fileExtension == "ts" ||
               m_fileExtension == "jsx" || m_fileExtension == "tsx") {
        setupJsRules();
    } else if (m_fileExtension == "py") {
        setupPythonRules();
    } else if (m_fileExtension == "qml") {
        setupQmlRules();
    } else {
        setupGenericRules();
    }
}

void SyntaxHighlighter::setupCppRules()
{
    QTextCharFormat keywordFormat;
    keywordFormat.setForeground(QColor("#cba6f7"));
    keywordFormat.setFontWeight(QFont::Bold);
    QStringList keywords = {
        "\\bauto\\b", "\\bbreak\\b", "\\bcase\\b", "\\bchar\\b", "\\bclass\\b",
        "\\bconst\\b", "\\bconstexpr\\b", "\\bcontinue\\b", "\\bdefault\\b", "\\bdelete\\b",
        "\\bdo\\b", "\\bdouble\\b", "\\belse\\b", "\\benum\\b", "\\bexplicit\\b",
        "\\bextern\\b", "\\bfalse\\b", "\\bfloat\\b", "\\bfor\\b", "\\bfriend\\b",
        "\\bgoto\\b", "\\bif\\b", "\\binline\\b", "\\bint\\b", "\\blong\\b",
        "\\bnamespace\\b", "\\bnew\\b", "\\bnoexcept\\b", "\\bnullptr\\b", "\\boperator\\b",
        "\\boverride\\b", "\\bprivate\\b", "\\bprotected\\b", "\\bpublic\\b", "\\breturn\\b",
        "\\bshort\\b", "\\bsigned\\b", "\\bsizeof\\b", "\\bstatic\\b", "\\bstruct\\b",
        "\\bswitch\\b", "\\btemplate\\b", "\\bthis\\b", "\\bthrow\\b", "\\btrue\\b",
        "\\btry\\b", "\\btypedef\\b", "\\btypename\\b", "\\bunion\\b", "\\bunsigned\\b",
        "\\busing\\b", "\\bvirtual\\b", "\\bvoid\\b", "\\bvolatile\\b", "\\bwhile\\b",
        "\\bslots\\b", "\\bsignals\\b", "\\bemit\\b",
        "\\bQ_OBJECT\\b", "\\bQ_PROPERTY\\b", "\\bQ_INVOKABLE\\b",
        "\\bQML_ELEMENT\\b", "\\bQML_SINGLETON\\b"
    };
    for (const QString &pattern : keywords) {
        HighlightRule rule;
        rule.pattern = QRegularExpression(pattern);
        rule.format = keywordFormat;
        m_rules.append(rule);
    }

    QTextCharFormat preprocessorFormat;
    preprocessorFormat.setForeground(QColor("#f38ba8"));
    HighlightRule preprocessor;
    preprocessor.pattern = QRegularExpression("^\\s*#\\w+.*");
    preprocessor.format = preprocessorFormat;
    m_rules.append(preprocessor);

    QTextCharFormat typeFormat;
    typeFormat.setForeground(QColor("#f9e2af"));
    HighlightRule typeRule;
    typeRule.pattern = QRegularExpression("\\b[A-Z][A-Za-z0-9_]*\\b");
    typeRule.format = typeFormat;
    m_rules.append(typeRule);

    QTextCharFormat functionFormat;
    functionFormat.setForeground(QColor("#89b4fa"));
    HighlightRule funcRule;
    funcRule.pattern = QRegularExpression("\\b[a-z_][A-Za-z0-9_]*(?=\\s*\\()");
    funcRule.format = functionFormat;
    m_rules.append(funcRule);

    QTextCharFormat numberFormat;
    numberFormat.setForeground(QColor("#fab387"));
    HighlightRule numRule;
    numRule.pattern = QRegularExpression("\\b[0-9]+\\.?[0-9]*[fFlLuU]*\\b");
    numRule.format = numberFormat;
    m_rules.append(numRule);

    QTextCharFormat stringFormat;
    stringFormat.setForeground(QColor("#a6e3a1"));
    HighlightRule stringRule;
    stringRule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
    stringRule.format = stringFormat;
    m_rules.append(stringRule);

    QTextCharFormat commentFormat;
    commentFormat.setForeground(QColor("#6c7086"));
    commentFormat.setFontItalic(true);
    HighlightRule lineComment;
    lineComment.pattern = QRegularExpression("//[^\n]*");
    lineComment.format = commentFormat;
    m_rules.append(lineComment);

    m_multiLineCommentFormat = commentFormat;
    m_commentStartExpression = QRegularExpression("/\\*");
    m_commentEndExpression = QRegularExpression("\\*/");
}

void SyntaxHighlighter::setupJsRules()
{
    QTextCharFormat keywordFormat;
    keywordFormat.setForeground(QColor("#cba6f7"));
    keywordFormat.setFontWeight(QFont::Bold);
    QStringList keywords = {
        "\\bvar\\b", "\\blet\\b", "\\bconst\\b", "\\bfunction\\b", "\\breturn\\b",
        "\\bif\\b", "\\belse\\b", "\\bfor\\b", "\\bwhile\\b", "\\bdo\\b",
        "\\bswitch\\b", "\\bcase\\b", "\\bbreak\\b", "\\bcontinue\\b", "\\bdefault\\b",
        "\\bnew\\b", "\\bdelete\\b", "\\btypeof\\b", "\\binstanceof\\b", "\\bin\\b",
        "\\btry\\b", "\\bcatch\\b", "\\bfinally\\b", "\\bthrow\\b",
        "\\bclass\\b", "\\bextends\\b", "\\bsuper\\b", "\\bthis\\b",
        "\\bimport\\b", "\\bexport\\b", "\\bfrom\\b", "\\bas\\b",
        "\\basync\\b", "\\bawait\\b", "\\byield\\b",
        "\\btrue\\b", "\\bfalse\\b", "\\bnull\\b", "\\bundefined\\b",
        "\\binterface\\b", "\\btype\\b", "\\benum\\b"
    };
    for (const QString &pattern : keywords) {
        HighlightRule rule;
        rule.pattern = QRegularExpression(pattern);
        rule.format = keywordFormat;
        m_rules.append(rule);
    }

    QTextCharFormat functionFormat;
    functionFormat.setForeground(QColor("#89b4fa"));
    HighlightRule funcRule;
    funcRule.pattern = QRegularExpression("\\b[a-z_][A-Za-z0-9_]*(?=\\s*\\()");
    funcRule.format = functionFormat;
    m_rules.append(funcRule);

    QTextCharFormat numberFormat;
    numberFormat.setForeground(QColor("#fab387"));
    HighlightRule numRule;
    numRule.pattern = QRegularExpression("\\b[0-9]+\\.?[0-9]*\\b");
    numRule.format = numberFormat;
    m_rules.append(numRule);

    QTextCharFormat stringFormat;
    stringFormat.setForeground(QColor("#a6e3a1"));
    HighlightRule stringRule;
    stringRule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'|`[^`]*`");
    stringRule.format = stringFormat;
    m_rules.append(stringRule);

    QTextCharFormat commentFormat;
    commentFormat.setForeground(QColor("#6c7086"));
    commentFormat.setFontItalic(true);
    HighlightRule lineComment;
    lineComment.pattern = QRegularExpression("//[^\n]*");
    lineComment.format = commentFormat;
    m_rules.append(lineComment);

    m_multiLineCommentFormat = commentFormat;
    m_commentStartExpression = QRegularExpression("/\\*");
    m_commentEndExpression = QRegularExpression("\\*/");
}

void SyntaxHighlighter::setupPythonRules()
{
    QTextCharFormat keywordFormat;
    keywordFormat.setForeground(QColor("#cba6f7"));
    keywordFormat.setFontWeight(QFont::Bold);
    QStringList keywords = {
        "\\band\\b", "\\bas\\b", "\\bassert\\b", "\\basync\\b", "\\bawait\\b",
        "\\bbreak\\b", "\\bclass\\b", "\\bcontinue\\b", "\\bdef\\b", "\\bdel\\b",
        "\\belif\\b", "\\belse\\b", "\\bexcept\\b", "\\bfinally\\b", "\\bfor\\b",
        "\\bfrom\\b", "\\bglobal\\b", "\\bif\\b", "\\bimport\\b", "\\bin\\b",
        "\\bis\\b", "\\blambda\\b", "\\bnot\\b", "\\bor\\b", "\\bpass\\b",
        "\\braise\\b", "\\breturn\\b", "\\btry\\b", "\\bwhile\\b", "\\bwith\\b",
        "\\byield\\b", "\\bTrue\\b", "\\bFalse\\b", "\\bNone\\b", "\\bself\\b"
    };
    for (const QString &pattern : keywords) {
        HighlightRule rule;
        rule.pattern = QRegularExpression(pattern);
        rule.format = keywordFormat;
        m_rules.append(rule);
    }

    QTextCharFormat decoratorFormat;
    decoratorFormat.setForeground(QColor("#f9e2af"));
    HighlightRule decoratorRule;
    decoratorRule.pattern = QRegularExpression("@\\w+");
    decoratorRule.format = decoratorFormat;
    m_rules.append(decoratorRule);

    QTextCharFormat functionFormat;
    functionFormat.setForeground(QColor("#89b4fa"));
    HighlightRule funcRule;
    funcRule.pattern = QRegularExpression("\\bdef\\s+(\\w+)");
    funcRule.format = functionFormat;
    m_rules.append(funcRule);

    QTextCharFormat numberFormat;
    numberFormat.setForeground(QColor("#fab387"));
    HighlightRule numRule;
    numRule.pattern = QRegularExpression("\\b[0-9]+\\.?[0-9]*\\b");
    numRule.format = numberFormat;
    m_rules.append(numRule);

    QTextCharFormat stringFormat;
    stringFormat.setForeground(QColor("#a6e3a1"));
    HighlightRule strRule1;
    strRule1.pattern = QRegularExpression("\"\"\"[^\"]*\"\"\"|'''[^']*'''|\"[^\"]*\"|'[^']*'");
    strRule1.format = stringFormat;
    m_rules.append(strRule1);

    QTextCharFormat commentFormat;
    commentFormat.setForeground(QColor("#6c7086"));
    commentFormat.setFontItalic(true);
    HighlightRule commentRule;
    commentRule.pattern = QRegularExpression("#[^\n]*");
    commentRule.format = commentFormat;
    m_rules.append(commentRule);

    m_commentStartExpression = QRegularExpression();
    m_commentEndExpression = QRegularExpression();
}

void SyntaxHighlighter::setupQmlRules()
{
    QTextCharFormat keywordFormat;
    keywordFormat.setForeground(QColor("#cba6f7"));
    keywordFormat.setFontWeight(QFont::Bold);
    QStringList keywords = {
        "\\bimport\\b", "\\bproperty\\b", "\\bsignal\\b", "\\breadonly\\b",
        "\\bfunction\\b", "\\bvar\\b", "\\blet\\b", "\\bconst\\b",
        "\\bif\\b", "\\belse\\b", "\\bfor\\b", "\\bwhile\\b", "\\breturn\\b",
        "\\btrue\\b", "\\bfalse\\b", "\\bnull\\b", "\\bundefined\\b",
        "\\balias\\b", "\\brequired\\b", "\\bdefault\\b",
        "\\bpragma\\b", "\\bSingleton\\b"
    };
    for (const QString &pattern : keywords) {
        HighlightRule rule;
        rule.pattern = QRegularExpression(pattern);
        rule.format = keywordFormat;
        m_rules.append(rule);
    }

    QTextCharFormat typeFormat;
    typeFormat.setForeground(QColor("#f9e2af"));
    HighlightRule typeRule;
    typeRule.pattern = QRegularExpression("\\b[A-Z][A-Za-z0-9_]*\\b");
    typeRule.format = typeFormat;
    m_rules.append(typeRule);

    QTextCharFormat propertyFormat;
    propertyFormat.setForeground(QColor("#89dceb"));
    HighlightRule propRule;
    propRule.pattern = QRegularExpression("\\b[a-z][A-Za-z0-9_]*(?=\\s*:)");
    propRule.format = propertyFormat;
    m_rules.append(propRule);

    QTextCharFormat numberFormat;
    numberFormat.setForeground(QColor("#fab387"));
    HighlightRule numRule;
    numRule.pattern = QRegularExpression("\\b[0-9]+\\.?[0-9]*\\b");
    numRule.format = numberFormat;
    m_rules.append(numRule);

    QTextCharFormat stringFormat;
    stringFormat.setForeground(QColor("#a6e3a1"));
    HighlightRule stringRule;
    stringRule.pattern = QRegularExpression("\"[^\"]*\"");
    stringRule.format = stringFormat;
    m_rules.append(stringRule);

    QTextCharFormat commentFormat;
    commentFormat.setForeground(QColor("#6c7086"));
    commentFormat.setFontItalic(true);
    HighlightRule lineComment;
    lineComment.pattern = QRegularExpression("//[^\n]*");
    lineComment.format = commentFormat;
    m_rules.append(lineComment);

    m_multiLineCommentFormat = commentFormat;
    m_commentStartExpression = QRegularExpression("/\\*");
    m_commentEndExpression = QRegularExpression("\\*/");
}

void SyntaxHighlighter::setupGenericRules()
{
    QTextCharFormat numberFormat;
    numberFormat.setForeground(QColor("#fab387"));
    HighlightRule numRule;
    numRule.pattern = QRegularExpression("\\b[0-9]+\\.?[0-9]*\\b");
    numRule.format = numberFormat;
    m_rules.append(numRule);

    QTextCharFormat stringFormat;
    stringFormat.setForeground(QColor("#a6e3a1"));
    HighlightRule stringRule;
    stringRule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
    stringRule.format = stringFormat;
    m_rules.append(stringRule);
}

void SyntaxHighlighter::highlightBlock(const QString &text)
{
    for (const HighlightRule &rule : m_rules) {
        QRegularExpressionMatchIterator it = rule.pattern.globalMatch(text);
        while (it.hasNext()) {
            QRegularExpressionMatch match = it.next();
            setFormat(match.capturedStart(), match.capturedLength(), rule.format);
        }
    }

    if (!m_commentStartExpression.pattern().isEmpty()) {
        setCurrentBlockState(0);
        int startIndex = 0;
        if (previousBlockState() != 1)
            startIndex = text.indexOf(m_commentStartExpression);

        while (startIndex >= 0) {
            QRegularExpressionMatch endMatch;
            int endIndex = text.indexOf(m_commentEndExpression, startIndex, &endMatch);
            int commentLength;
            if (endIndex == -1) {
                setCurrentBlockState(1);
                commentLength = text.length() - startIndex;
            } else {
                commentLength = endIndex - startIndex + endMatch.capturedLength();
            }
            setFormat(startIndex, commentLength, m_multiLineCommentFormat);
            startIndex = text.indexOf(m_commentStartExpression, startIndex + commentLength);
        }
    }
}
