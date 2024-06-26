#!/bin/bash

# 引数のチェック
if [ "$#" -ne 1 ] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
  echo "Usage: $0 positive_integer" >&2
  exit 1
fi

generateClassFile() {
  for i in $(seq 1 $1)
  do
    className="Class$i"
    fileName="$className.kt"
    fileContent="class $className {
    fun print() {
        println(\"$className\")
    }
  }"
    echo "$fileContent" > "./kotlin1.9/src/main/kotlin/$fileName"
    echo "$fileContent" > "./kotlin2.0/src/main/kotlin/$fileName"
  done
}

removeClassFiles() {
  rm -rf ./kotlin1.9/src/main/kotlin/Class*.kt
  rm -rf ./kotlin2.0/src/main/kotlin/Class*.kt
}

generateClassFile $1

# コンパイラのパフォーマンスを正確に測定するために以下のオプションを設定
#--no-build-cache: Gradleのビルドキャッシュを無効にします。これにより、各ビルドがキャッシュなしで完全に新規に行われることを保証します。
#--no-daemon: Gradleのデーモンプロセスを使用せずにビルドを実行します。これにより、デーモンプロセスがビルド時間に影響を与える可能性を排除します。
#--quiet: Gradleの必要最低限の情報のみを出力します。これにより、ビルドの出力がベンチマークの結果に影響を与える可能性を排除します。

echo "Benchmarking start"

./gradlew :kotlin1.9:kotlinCompilerVersion --quiet
./gradlew :kotlin1.9:clean --quiet > /dev/null 2>&1
start19=$(python -c 'import time; print(int(time.time() * 1000))')
./gradlew :kotlin1.9:build --no-daemon --quiet --no-build-cache > /dev/null 2>&1
end19=$(python -c 'import time; print(int(time.time() * 1000))')
echo "Kotlin 1.9 compile time: $((end19 - start19)) ms"

./gradlew :kotlin2.0:kotlinCompilerVersion --quiet
./gradlew :kotlin2.0:clean --quiet > /dev/null 2>&1
start20=$(python -c 'import time; print(int(time.time() * 1000))')
./gradlew :kotlin2.0:build --no-daemon --quiet --no-build-cache > /dev/null 2>&1
end20=$(python -c 'import time; print(int(time.time() * 1000))')
echo "Kotlin 2.0 compile time: $((end20 - start20)) ms"

echo "Benchmarking end"

removeClassFiles
