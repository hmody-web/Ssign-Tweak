# Ssign — مشروع الواجهة والتويك

هذا المشروع مجهز لتطبيق ESign 5.0.2 الذي تم فحصه، ويستهدف الكلاسات الموجودة فعليًا داخله مثل:
- `YYYAppListViewController`
- `YYYAppTableViewCell`
- `YYYSettingTableViewController`
- `YYYTabBarViewController`

## ما الذي يغيره؟

- ثيم داكن حديث مع أزرق كلون افتراضي.
- كروت تطبيقات دائرية ومرتبة.
- اتجاه عربي RTL.
- عنوان `التطبيقات` و`الإعدادات` بالعربي.
- صفحة/جزء المطور داخل الإعدادات:
  - المطور: محمد السراي
  - `scrptaty.com`
- زر `المظهر` داخل الإعدادات لاختيار:
  - أزرق
  - بنفسجي
  - سماوي
  - أخضر
  - برتقالي
  - وردي
- يستخدم شعار Ssign المرفق.
- سكربت منفصل يغير اسم التطبيق إلى `Ssign` وأيقونة الشاشة الرئيسية.

## 1. تعديل الاسم والأيقونة

على Windows:

```cmd
python patch_ipa.py esign_v5.0.2.ipa SsignLogo.png Ssign_base.ipa
```

يتطلب:
```cmd
pip install pillow
```

> السكربت لا يغير Bundle ID.

## 2. بناء ملف التويك

المشروع مصدر Theos. بعد وجود Theos + iOS toolchain:

```bash
make clean package
```

ملف dylib الناتج سيكون داخل مجلد `.theos/obj/...` باسم قريب من:

`SsignTheme.dylib`

## 3. الدمج

في iPA Edit:
1. اختر `1. Inject tweaks`
2. اختر `Ssign_base.ipa`
3. اختر `SsignTheme.dylib`
4. احفظ IPA المعدل.

## 4. إعادة التوقيع

بعد الحقن اختر في iPA Edit:

`4. Sign IPA with certificate`

واستخدم:
- ملف `.p12`
- ملف `.mobileprovision`
- كلمة مرور الشهادة

## ملاحظة

تغيير الواجهة يتم عبر Runtime Hooks، لذلك يمكن أن تحتاج بعض التفاصيل الدقيقة إلى تعديل حسب إصدار ESign إذا تغيرت أسماء الكلاسات في إصدار آخر.
