#include "Settings.h"

Settings::Settings(QObject *parent)
    : QObject(parent)
    , m_settings("UseLlama", "UseLlama")
{
}

QString Settings::ollamaUrl() const
{
    return m_settings.value("ollama/url", "http://localhost:11434").toString();
}

void Settings::setOllamaUrl(const QString &url)
{
    if (ollamaUrl() != url) {
        m_settings.setValue("ollama/url", url);
        emit ollamaUrlChanged();
    }
}

QString Settings::defaultModel() const
{
    return m_settings.value("ollama/defaultModel", "").toString();
}

void Settings::setDefaultModel(const QString &model)
{
    if (defaultModel() != model) {
        m_settings.setValue("ollama/defaultModel", model);
        emit defaultModelChanged();
    }
}

int Settings::fontSize() const
{
    return m_settings.value("editor/fontSize", 14).toInt();
}

void Settings::setFontSize(int size)
{
    if (fontSize() != size) {
        m_settings.setValue("editor/fontSize", size);
        emit fontSizeChanged();
    }
}

double Settings::temperature() const
{
    return m_settings.value("ollama/temperature", 0.7).toDouble();
}

void Settings::setTemperature(double temp)
{
    if (qFuzzyCompare(temperature(), temp)) return;
    m_settings.setValue("ollama/temperature", temp);
    emit temperatureChanged();
}

int Settings::contextLength() const
{
    return m_settings.value("ollama/contextLength", 8192).toInt();
}

void Settings::setContextLength(int length)
{
    if (contextLength() != length) {
        m_settings.setValue("ollama/contextLength", length);
        emit contextLengthChanged();
    }
}
