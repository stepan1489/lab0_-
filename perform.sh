#!/usr/bin/env bash
mkdir -p victor/{kitchen/{molecular_station,hot_station},hall,office}
mkdir experiments archive_empty

cat > victor/kitchen/molecular_station/foam_recipe <<'EOF'
Катя готовит свекольную пену для нового блюда
Лёва проверяет температуру перед подачей
Баринов требует сохранить вкус продуктов
Рецепт отправят на вечернюю дегустацию
EOF

cat > victor/kitchen/molecular_station/nitrogen_notes <<'EOF'
Баллон с азотом доставлен утром
Катя проверила защитные перчатки
Сеня держится подальше от оборудования
После опыта рабочее место нужно убрать
EOF

cat > victor/kitchen/hot_station/senya_report <<'EOF'
Сеня подготовил мясо для горячего блюда
Первая партия отправлена в зал
Шеф потребовал переделать соус
К вечеру заказ был выполнен
EOF

cat > victor/kitchen/hot_station/fedya_report <<'EOF'
Федя получил свежую рыбу
Дорадо подготовлена для постоянных гостей
Катя предложила необычную подачу блюда
Баринов одобрил только второй вариант
EOF

cat > victor/kitchen/chef_order <<'EOF'
Баринов проводит дегустацию после обеда
Каждый повар представляет одно новое блюдо
Катя отвечает за молекулярную часть меню
Результаты передать Лёве до вечерней смены
EOF

cat > victor/hall/reservations <<'EOF'
Столик два забронирован для критика
Столик пять подготовить к семнадцати часам
Большой стол оставить для команды ресторана
Вика проверит готовность зала перед открытием
EOF

cat > victor/hall/guest_reviews <<'EOF'
Гости похвалили необычную подачу блюда
Один гость попросил вернуть обычный десерт
Критик отметил точность работы Кати
Новое меню вызвало интерес у посетителей
EOF

cat > victor/office/katya_schedule <<'EOF'
Катя приходит на кухню к десяти часам
До обеда проводится первый опыт
После дегустации нужно встретиться с Бариновым
Вечером Катя помогает Лёве закрыть смену
EOF

cat > experiments/tasting_results <<'EOF'
Свекольная пена получила высокую оценку
Рыбное блюдо нужно подать горячее
Сеня предложил изменить мясной соус
Катя подготовит итоговый рецепт вечером
EOF

cat > opening_message <<'EOF'
Ресторан Victor открывается в полдень
Вика встречает первых гостей
Баринов лично проверяет новое меню
Команда собирается на кухне до открытия
EOF

chmod 755 victor
chmod a-rwx,u+rwx,g+rx victor/kitchen
chmod 750 victor/kitchen/molecular_station
chmod a-rwx,u+rw,g+r victor/kitchen/molecular_station/foam_recipe
chmod 640 victor/kitchen/molecular_station/nitrogen_notes
chmod a-rwx,u+rwx,g+rx victor/kitchen/hot_station
chmod 644 victor/kitchen/hot_station/senya_report
chmod a-rwx,u+rw,go+r victor/kitchen/hot_station/fedya_report
chmod 640 victor/kitchen/chef_order
chmod a-rwx,ugo+rx,u+w victor/hall
chmod 664 victor/hall/reservations
chmod a-rwx,ugo+r victor/hall/guest_reviews
chmod 750 victor/office
chmod a-rwx,u+rw,g+r victor/office/katya_schedule
chmod a-rwx,u+rwx,g+rx experiments
chmod 660 experiments/tasting_results
chmod 700 archive_empty
chmod a-rwx,u+rw,go+r opening_message

cp experiments/tasting_results victor/office/successful_experiment
cp -r victor/kitchen/molecular_station experiments/molecular_backup
ln -s ../victor/kitchen/molecular_station/foam_recipe experiments/current_recipe
ln -s victor/kitchen kitchen_entry
ln opening_message victor/kitchen/shift_order
cat victor/kitchen/hot_station/senya_report victor/kitchen/hot_station/fedya_report > victor/kitchen/team_report
cat victor/kitchen/chef_order >> experiments/tasting_results
mv victor/hall/reservations victor/office/evening_reservations

ls -lR victor experiments archive_empty opening_message | grep '^-' | sort -nk5 | tail -n 5
grep -rhiE 'катя|баринов' victor experiments | grep -vi 'гост' | sort -r | head -n 6
grep -ril 'катя' victor/kitchen/molecular_station experiments/molecular_backup | wc -l
(head -q -n 1 victor/kitchen/hot_station/*_report; tail -q -n 1 victor/kitchen/hot_station/*_report) | grep -Ei 'блюд|баринов' | sort
grep -vE 'Сеня|Федя' victor/kitchen/team_report | grep 'блюд' | sort -r | wc -w
ls -lR | grep '^l' | sort -rk9
ls -liR | awk '$2 ~ /^-/ && $3 == 2' | sort -n -k1

rm experiments/tasting_results
rm experiments/current_recipe
rm kitchen_entry
rm opening_message
rm victor/kitchen/shift_order
rm victor/kitchen/molecular_station/nitrogen_notes
rmdir archive_empty
rm -r experiments/molecular_backup
