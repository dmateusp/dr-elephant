//
// Copyright 2016 LinkedIn Corp.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.
//

import play.Project._
import sbt._

object Dependencies {

  // Dependency Version
  lazy val commonsCodecVersion = "1.10"
  lazy val commonsIoVersion = "2.4"
  lazy val gsonVersion = "2.2.4"
  lazy val guavaVersion = "18.0"          // Hadoop defaultly are using guava 11.0, might raise NoSuchMethodException
  lazy val jacksonMapperAslVersion = "1.7.3"
  lazy val jacksonVersion = "2.5.3"
  lazy val jerseyVersion = "2.24"
  lazy val jsoupVersion = "1.7.3"
  lazy val mysqlConnectorVersion = "5.1.36"
  lazy val oozieClientVersion = "4.2.0"

  // System properties
  val HADOOP_VERSION = "hadoopversion"
  val SPARK_VERSION = "sparkversion"

  val defaultHadoopVersion = "2.3.0"
  val hadoopVersion = Option(System.getProperties.getProperty(HADOOP_VERSION)).getOrElse(defaultHadoopVersion)
  println(s"HADOOP version: $hadoopVersion")

  val defaultSparkVersion = "1.4.0"
  val sparkVersion = Option(System.getProperties.getProperty(SPARK_VERSION)).getOrElse(defaultSparkVersion)
  println(s"SPARK version: $sparkVersion")


  val sparkExclusion = if (sparkVersion >= "1.5.0") {
    "org.apache.spark" % "spark-core_2.10" % sparkVersion excludeAll(
      ExclusionRule(organization = "com.typesafe.akka"),
      ExclusionRule(organization = "org.apache.avro"),
      ExclusionRule(organization = "org.apache.hadoop"),
      ExclusionRule(organization = "net.razorvine")
      )
  } else {
    "org.apache.spark" % "spark-core_2.10" % sparkVersion excludeAll(
      ExclusionRule(organization = "org.apache.avro"),
      ExclusionRule(organization = "org.apache.hadoop"),
      ExclusionRule(organization = "net.razorvine")
      )
  }

  // Dependency coordinates
  val requiredDep = Seq(
    "com.google.code.gson" % "gson" % gsonVersion,
    "com.google.guava" % "guava" % guavaVersion,
    "com.jsuereth" %% "scala-arm" % "1.4",
    "commons-codec" % "commons-codec" % commonsCodecVersion,
    "commons-io" % "commons-io" % commonsIoVersion,
    "javax.ws.rs" % "javax.ws.rs-api" % "2.0.1",
    "mysql" % "mysql-connector-java" % mysqlConnectorVersion,
    "org.apache.hadoop" % "hadoop-auth" % hadoopVersion % "compileonly",
    "org.apache.hadoop" % "hadoop-mapreduce-client-core" % hadoopVersion % "compileonly",
    "org.apache.hadoop" % "hadoop-mapreduce-client-core" % hadoopVersion % Test,
    "org.apache.hadoop" % "hadoop-mapreduce-client-core" % hadoopVersion % Runtime,
    "org.apache.hadoop" % "hadoop-common" % hadoopVersion % "compileonly",
    "org.apache.hadoop" % "hadoop-common" % hadoopVersion % Test,
    "org.apache.hadoop" % "hadoop-common" % hadoopVersion % Runtime,
    "org.apache.hadoop" % "hadoop-hdfs" % hadoopVersion % "compileonly",
    "org.apache.hadoop" % "hadoop-hdfs" % hadoopVersion % Test,
    "org.apache.hadoop" % "hadoop-hdfs" % hadoopVersion % Runtime,
    "org.jsoup" % "jsoup" % jsoupVersion,
    "org.apache.oozie" % "oozie-client" % oozieClientVersion excludeAll(
      ExclusionRule(organization = "org.apache.hadoop")
      ),
    "org.glassfish.jersey.core" % "jersey-client" % jerseyVersion,
    "org.glassfish.jersey.core" % "jersey-common" % jerseyVersion,
    "org.glassfish.jersey.media" % "jersey-media-json-jackson" % jerseyVersion % Test,
    "org.glassfish.jersey.test-framework" % "jersey-test-framework-core" % jerseyVersion % Test,
    "org.glassfish.jersey.test-framework.providers" % "jersey-test-framework-provider-grizzly2" % jerseyVersion % Test,
    "com.fasterxml.jackson.core" % "jackson-databind" % jacksonVersion,
    "com.fasterxml.jackson.module" %% "jackson-module-scala" % jacksonVersion,
    "io.dropwizard.metrics" % "metrics-core" % "3.1.2",
    "io.dropwizard.metrics" % "metrics-healthchecks" % "3.1.2",
    "org.mockito" % "mockito-core" % "1.10.19" exclude ("org.hamcrest", "hamcrest-core"),
    "org.jmockit" % "jmockit" % "1.23" % Test,
    "org.apache.httpcomponents" % "httpclient" % "4.5.2",
    "org.apache.httpcomponents" % "httpcore" % "4.4.4",
    "org.scalatest" %% "scalatest" % "3.0.0" % Test,
    "com.h2database" % "h2" % "1.4.196" % Test
  ) :+ sparkExclusion

  val dependencies = Seq(javaJdbc, javaEbean, cache) ++ requiredDep

  val exclusionRules = Seq(
    ExclusionRule(organization = "com.sun.jersey", name = "jersey-core"),
    ExclusionRule(organization = "com.sun.jersey", name = "jersey-server")
  )
}
