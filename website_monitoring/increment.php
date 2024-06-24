<?php
$file = 'counters.json';

// Перевірка та створення файлу лічильників
if (!file_exists($file)) {
    // Ініціалізуємо лічильники з нулями
    $initialCounts = array_fill(0, 9, 0); // 9 лічильників, починаючи з нуля
    file_put_contents($file, json_encode($initialCounts));
}

// Отримання номера лічильника з GET параметру
$counterIndex = isset($_GET['counter']) ? intval($_GET['counter']) : 0;

// Збільшення відповідного лічильника
$counters = json_decode(file_get_contents($file), true);
if ($counterIndex >= 0 && $counterIndex < count($counters)) {
    $counters[$counterIndex]++;
} else {
    // Якщо номер лічильника некоректний, збільшуємо загальний лічильник
    $counters[0]++;
}
file_put_contents($file, json_encode($counters));
?>
