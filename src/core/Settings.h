#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>
#include <QQmlEngine>

class Settings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString ollamaUrl READ ollamaUrl WRITE setOllamaUrl NOTIFY ollamaUrlChanged)
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged)
    Q_PROPERTY(QString defaultModel READ defaultModel WRITE setDefaultModel NOTIFY defaultModelChanged)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(double temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged)
    Q_PROPERTY(int contextLength READ contextLength WRITE setContextLength NOTIFY contextLengthChanged)
    Q_PROPERTY(bool hasApiKey READ hasApiKey NOTIFY apiKeyChanged)
    Q_PROPERTY(QString colorTheme READ colorTheme WRITE setColorTheme NOTIFY colorThemeChanged)
    Q_PROPERTY(QString apiMode READ apiMode WRITE setApiMode NOTIFY apiModeChanged)

public:
    explicit Settings(QObject *parent = nullptr);

    QString ollamaUrl() const;
    void setOllamaUrl(const QString &url);

    QString apiKey() const;
    void setApiKey(const QString &key);
    bool hasApiKey() const;

    QString defaultModel() const;
    void setDefaultModel(const QString &model);

    int fontSize() const;
    void setFontSize(int size);

    double temperature() const;
    void setTemperature(double temp);

    int contextLength() const;
    void setContextLength(int length);

    QString colorTheme() const;
    void setColorTheme(const QString &theme);

    QString apiMode() const;
    void setApiMode(const QString &mode);

signals:
    void ollamaUrlChanged();
    void apiKeyChanged();
    void defaultModelChanged();
    void fontSizeChanged();
    void temperatureChanged();
    void contextLengthChanged();
    void colorThemeChanged();
    void apiModeChanged();

private:
    QSettings m_settings;
};

#endif // SETTINGS_H
