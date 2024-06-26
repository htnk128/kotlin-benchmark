import java.io.File

fun main() {
    for (i in 1..10000) {
        val className = "Class$i"
        val fileName = "$className.kt"
        val fileContent = """
            class $className {
                fun print() {
                    println("$className")
                }
            }
        """.trimIndent()

        File(fileName).writer().use { it.write(fileContent) }
    }
}