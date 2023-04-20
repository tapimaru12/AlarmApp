import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class Alarm {
    
    var timer: Timer?
    
    // アラームがセットされているかどうか
    var isSet = false
    
    // アラームが鳴っているかどうか
    var ringing = false
    
    // アラームを鳴らす曜日
    var setDay: String = ""
    // 現在の曜日を取得する際のフォーマット
    var weekdayFormatter = DateFormatter()
    // 各プロパティに対する変更がクラス内で直接書けなかったため、メソッドとしてまとめる
    func weekdayFormat() {
        weekdayFormatter.locale = Locale(identifier: "ja_JP")
        weekdayFormatter.timeZone = TimeZone(abbreviation: "JST")
        weekdayFormatter.dateFormat = "E"
    }
    
    // アラームを鳴らす時刻
    var setTime: String = ""
    // 現在の時刻を取得する際のフォーマット
    var timeFormatter = DateFormatter()
    // 各プロパティに対する変更がクラス内で直接書けなかったため、メソッドとしてまとめる
    func timeFormat() {
        timeFormatter.locale = Locale(identifier: "ja_JP")
        timeFormatter.timeZone = TimeZone(abbreviation: "JST")
        timeFormatter.timeStyle = .short
        timeFormatter.dateFormat = "HH:mm"
    }

    
    // 引数-[曜日, 時刻]
    func setAlarm(d: String, t: String) {
        if !isSet && !ringing {
            weekdayFormat()
            timeFormat()
            setDay = d
            setTime = t
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(compare), userInfo: nil, repeats: true)
            isSet = true
        }
    }
    
    // 現在の曜日＆時刻が、指定した曜日＆時刻と同じならアラームを鳴らす
    @objc func compare() {
        if setDay == weekdayFormatter.string(from: Date()) && setTime == timeFormatter.string(from: Date()) {
            if !ringing { ringing = true }
            print("⏰")
        }
    }
    
    // スヌーズボタンを押した時の処理(アラームが鳴っている時のみ有効)
    func tappedSnoozeButton(snoozeTime: Int) {
        if ringing {
            // setTimeを一旦Date型に変換
            if let timeDate = timeFormatter.date(from: setTime) {
                // 引数のスヌーズ時間をsetTimeに加算(分単位)
                var snooze = Calendar.current.date(byAdding: .minute, value: snoozeTime, to: timeDate)
                // 再度アラームを鳴らす時刻を設定
                setTime = timeFormatter.string(from: snooze!)
                print("スヌーズ中　\(setTime)")
                // アラームを止める
                ringing = false
                timer?.invalidate()
                // アラームのセットフラグをfalseに変更
                isSet = false
                // 新しいアラームをセット
                setAlarm(d: setDay, t: setTime)
            }
        }
    }
    
    // ストップボタンを押した時の処理(アラームが鳴っている時のみ有効)
    func tappedStopButton() {
        if ringing {
            print("Stop")
            isSet = false
            ringing = false
            timer?.invalidate()
        }
    }
    
    // リセットボタンを押した時の処理(アラームをセットしてからアラームが鳴るまでの間＆スヌーズ中のみ有効)
    func tappedResetButton() {
        if isSet && !ringing {
            isSet = false
            timer?.invalidate()
        }
    }
}





let alarm = Alarm()

// アラームをセットする
alarm.setAlarm(d: "金", t: "20:00")

// アラームが鳴る前にリセットする
alarm.tappedResetButton()

// 再度アラームをセット
alarm.setAlarm(d: "金", t: "20:05")

// スヌーズ
alarm.tappedSnoozeButton(snoozeTime: 1)

// アラームを止める
alarm.tappedStopButton()

