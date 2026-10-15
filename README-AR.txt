CHEM-VIRSE — لوحة التحكم

الملفات في جذر الموقع مباشرة، ولا تحتاج إلى نقلها من مجلد داخلي.

تشغيل لوحة التحكم:
1) ارفع جميع ملفات ZIP إلى جذر الاستضافة كما هي بعد فك الضغط.
2) افتح Supabase > SQL Editor وشغّل supabase-schema.sql (إن لم يكن قد شُغّل سابقًا).
3) شغّل supabase-admin-schema.sql.
4) أنشئ حساب المسؤول من Supabase Authentication > Users أو من صفحة dashboard.html.
5) انسخ UUID الخاص بحساب المسؤول من Authentication > Users، ثم نفّذ في SQL Editor مع استبدال UUID:
   insert into public.admin_users(user_id) values ('USER-UUID-HERE');
   لا تشارك UUID أو بيانات الدخول علنًا. لا تضف المستخدمين العاديين إلى admin_users.
6) افتح /dashboard.html وسجّل الدخول بحساب المسؤول.

الميزات: إدارة المواد بحسب الفرقة والفصل، إنشاء وتعديل الاختبارات، إضافة أسئلة الاختيار من متعدد، نشر وتعديل وحذف الإعلانات، عرض وحذف نوت الطلاب، ورفع ملفات وربطها بالمادة.

مهم: لوحة التحكم تستخدم Supabase الحالي الموجود في index.html. لا تضع service_role أو secret key في المتصفح. تشغيل لوحة الإدارة يحتاج تنفيذ ملف SQL أعلاه وإضافة UUID للمسؤول يدويًا. ملفات Storage ترفع إلى bucket باسم course-files الذي ينشئه SQL.
