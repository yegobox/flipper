# Keep Google Play Services Credentials API classes
-keep class com.google.android.gms.auth.api.credentials.** { *; }

# Keep all SmartAuthPlugin classes
-keep class fman.ge.smart_auth.** { *; }

# Ditto Live Proguard Rules
# Keep all Ditto classes and their members
-keep class live.ditto.** { *; }
-keep class com.ditto.** { *; }

# Keep Ditto JNI interfaces
-keep class * extends live.ditto.Ditto { *; }
-keep class * implements live.ditto.Ditto { *; }

# Keep Ditto transport classes
-keep class live.ditto.transports.** { *; }

# Keep Ditto sync classes
-keep class live.ditto.sync.** { *; }

# Keep Ditto store classes
-keep class live.ditto.store.** { *; }

# Keep Ditto authentication classes
-keep class live.ditto.auth.** { *; }

# Keep Ditto error classes
-keep class live.ditto.error.** { *; }

# Keep Ditto live query classes
-keep class live.ditto.livequery.** { *; }

# Keep Ditto presence classes
-keep class live.ditto.presence.** { *; }

# Keep Ditto attachment classes
-keep class live.ditto.attachment.** { *; }

# Keep Ditto logging classes
-keep class live.ditto.logging.** { *; }

# Keep Ditto internal classes
-keep class live.ditto.internal.** { *; }

# Keep Ditto Android specific classes
-keep class live.ditto.android.** { *; }

# Keep Ditto LiveQuery and related classes
-keep class * extends live.ditto.livequery.LiveQuery { *; }
-keep class * implements live.ditto.livequery.LiveQuery { *; }

# Keep Ditto Observer classes
-keep class * extends live.ditto.store.Observer { *; }
-keep class * implements live.ditto.store.Observer { *; }

# Keep Ditto Subscription classes
-keep class * extends live.ditto.store.Subscription { *; }
-keep class * implements live.ditto.store.Subscription { *; }

# Keep Ditto Document classes
-keep class live.ditto.store.Document { *; }
-keep class live.ditto.store.DocumentId { *; }

# Keep Ditto QueryResult classes
-keep class live.ditto.store.QueryResult { *; }
-keep class live.ditto.store.QueryResultItem { *; }

# Keep Ditto MutableDocument classes
-keep class live.ditto.store.MutableDocument { *; }

# Keep Ditto DQL (Ditto Query Language) classes
-keep class live.ditto.dql.** { *; }

# Keep Ditto JSON serialization classes
-keep class live.ditto.json.** { *; }

# Keep Ditto codec classes
-keep class live.ditto.codec.** { *; }

# Keep Ditto crypto classes
-keep class live.ditto.crypto.** { *; }

# Keep Ditto network classes
-keep class live.ditto.network.** { *; }

# Keep Ditto peer classes
-keep class live.ditto.peer.** { *; }

# Keep Ditto mesh classes
-keep class live.ditto.mesh.** { *; }

# Keep Ditto Bluetooth classes
-keep class live.ditto.bluetooth.** { *; }

# Keep Ditto WiFi classes
-keep class live.ditto.wifi.** { *; }

# Keep Ditto Cloud classes
-keep class live.ditto.cloud.** { *; }

# Keep Ditto WebSocket classes
-keep class live.ditto.websocket.** { *; }

# Keep Ditto HTTP classes
-keep class live.ditto.http.** { *; }

# Keep Ditto MQTT classes
-keep class live.ditto.mqtt.** { *; }

# Keep Ditto UDP classes
-keep class live.ditto.udp.** { *; }

# Keep Ditto TCP classes
-keep class live.ditto.tcp.** { *; }

# Keep Ditto serialization classes
-keep class live.ditto.serialization.** { *; }

# Keep Ditto deserialization classes
-keep class live.ditto.deserialization.** { *; }

# Keep Ditto compression classes
-keep class live.ditto.compression.** { *; }

# Keep Ditto encryption classes
-keep class live.ditto.encryption.** { *; }

# Keep Ditto decryption classes
-keep class live.ditto.decryption.** { *; }

# Keep Ditto hash classes
-keep class live.ditto.hash.** { *; }

# Keep Ditto signature classes
-keep class live.ditto.signature.** { *; }

# Keep Ditto verification classes
-keep class live.ditto.verification.** { *; }

# Keep Ditto certificate classes
-keep class live.ditto.certificate.** { *; }

# Keep Ditto key classes
-keep class live.ditto.key.** { *; }

# Keep Ditto token classes
-keep class live.ditto.token.** { *; }

# Keep Ditto session classes
-keep class live.ditto.session.** { *; }

# Keep Ditto connection classes
-keep class live.ditto.connection.** { *; }

# Keep Ditto disconnection classes
-keep class live.ditto.disconnection.** { *; }

# Keep Ditto reconnection classes
-keep class live.ditto.reconnection.** { *; }

# Keep Ditto heartbeat classes
-keep class live.ditto.heartbeat.** { *; }

# Keep Ditto ping classes
-keep class live.ditto.ping.** { *; }

# Keep Ditto pong classes
-keep class live.ditto.pong.** { *; }

# Keep Ditto timeout classes
-keep class live.ditto.timeout.** { *; }

# Keep Ditto retry classes
-keep class live.ditto.retry.** { *; }

# Keep Ditto backoff classes
-keep class live.ditto.backoff.** { *; }

# Keep Ditto exponential backoff classes
-keep class live.ditto.exponential_backoff.** { *; }

# Keep Ditto linear backoff classes
-keep class live.ditto.linear_backoff.** { *; }

# Keep Ditto constant backoff classes
-keep class live.ditto.constant_backoff.** { *; }

# Keep Ditto jitter classes
-keep class live.ditto.jitter.** { *; }

# Keep Ditto random jitter classes
-keep class live.ditto.random_jitter.** { *; }

# Keep Ditto full jitter classes
-keep class live.ditto.full_jitter.** { *; }

# Keep Ditto equal jitter classes
-keep class live.ditto.equal_jitter.** { *; }

# Keep Ditto decorrelated jitter classes
-keep class live.ditto.decorrelated_jitter.** { *; }

# Keep Ditto exponential backoff with jitter classes
-keep class live.ditto.exponential_backoff_with_jitter.** { *; }

# Keep Ditto linear backoff with jitter classes
-keep class live.ditto.linear_backoff_with_jitter.** { *; }

# Keep Ditto constant backoff with jitter classes
-keep class live.ditto.constant_backoff_with_jitter.** { *; }

# Keep Ditto backoff strategy classes
-keep class live.ditto.backoff_strategy.** { *; }

# Keep Ditto retry strategy classes
-keep class live.ditto.retry_strategy.** { *; }

# Keep Ditto circuit breaker classes
-keep class live.ditto.circuit_breaker.** { *; }

# Keep Ditto rate limiter classes
-keep class live.ditto.rate_limiter.** { *; }

# Keep Ditto bulkhead classes
-keep class live.ditto.bulkhead.** { *; }

# Keep Ditto timeout classes
-keep class live.ditto.timeout.** { *; }

# Keep Ditto deadline classes
-keep class live.ditto.deadline.** { *; }

# Keep Ditto cancellation classes
-keep class live.ditto.cancellation.** { *; }

# Keep Ditto context classes
-keep class live.ditto.context.** { *; }

# Keep Ditto future classes
-keep class live.ditto.future.** { *; }

# Keep Ditto promise classes
-keep class live.ditto.promise.** { *; }

# Keep Ditto completable classes
-keep class live.ditto.completable.** { *; }

# Keep Ditto observable classes
-keep class live.ditto.observable.** { *; }

# Keep Ditto observer classes
-keep class live.ditto.observer.** { *; }

# Keep Ditto subscriber classes
-keep class live.ditto.subscriber.** { *; }

# Keep Ditto subscription classes
-keep class live.ditto.subscription.** { *; }

# Keep Ditto disposable classes
-keep class live.ditto.disposable.** { *; }

# Keep Ditto scheduler classes
-keep class live.ditto.scheduler.** { *; }

# Keep Ditto thread pool classes
-keep class live.ditto.thread_pool.** { *; }

# Keep Ditto executor classes
-keep class live.ditto.executor.** { *; }

# Keep Ditto thread classes
-keep class live.ditto.thread.** { *; }

# Keep Ditto coroutine classes
-keep class live.ditto.coroutine.** { *; }

# Keep Ditto async classes
-keep class live.ditto.async.** { *; }

# Keep Ditto await classes
-keep class live.ditto.await.** { *; }

# Keep Ditto yield classes
-keep class live.ditto.yield.** { *; }

# Keep Ditto suspend classes
-keep class live.ditto.suspend.** { *; }

# Keep Ditto resume classes
-keep class live.ditto.resume.** { *; }

# Keep Ditto continuation classes
-keep class live.ditto.continuation.** { *; }

# Keep Ditto callback classes
-keep class live.ditto.callback.** { *; }

# Keep Ditto listener classes
-keep class live.ditto.listener.** { *; }

# Keep Ditto event classes
-keep class live.ditto.event.** { *; }

# Keep Ditto handler classes
-keep class live.ditto.handler.** { *; }

# Keep Ditto processor classes
-keep class live.ditto.processor.** { *; }

# Keep Ditto consumer classes
-keep class live.ditto.consumer.** { *; }

# Keep Ditto producer classes
-keep class live.ditto.producer.** { *; }

# Keep Ditto queue classes
-keep class live.ditto.queue.** { *; }

# Keep Ditto stack classes
-keep class live.ditto.stack.** { *; }

# Keep Ditto list classes
-keep class live.ditto.list.** { *; }

# Keep Ditto set classes
-keep class live.ditto.set.** { *; }

# Keep Ditto map classes
-keep class live.ditto.map.** { *; }

# Keep Ditto collection classes
-keep class live.ditto.collection.** { *; }

# Keep Ditto iterator classes
-keep class live.ditto.iterator.** { *; }

# Keep Ditto iterable classes
-keep class live.ditto.iterable.** { *; }

# Keep Ditto stream classes
-keep class live.ditto.stream.** { *; }

# Keep Ditto flow classes
-keep class live.ditto.flow.** { *; }

# Keep Ditto channel classes
-keep class live.ditto.channel.** { *; }

# Keep Ditto actor classes
-keep class live.ditto.actor.** { *; }

# Keep Ditto message classes
-keep class live.ditto.message.** { *; }

# Keep Ditto mailbox classes
-keep class live.ditto.mailbox.** { *; }

# Keep Ditto dispatcher classes
-keep class live.ditto.dispatcher.** { *; }

# Keep Ditto router classes
-keep class live.ditto.router.** { *; }

# Keep Ditto balancer classes
-keep class live.ditto.balancer.** { *; }

# Keep Ditto pool classes
-keep class live.ditto.pool.** { *; }

# Keep Ditto factory classes
-keep class live.ditto.factory.** { *; }

# Keep Ditto builder classes
-keep class live.ditto.builder.** { *; }

# Keep Ditto configuration classes
-keep class live.ditto.configuration.** { *; }

# Keep Ditto settings classes
-keep class live.ditto.settings.** { *; }

# Keep Ditto options classes
-keep class live.ditto.options.** { *; }

# Keep Ditto properties classes
-keep class live.ditto.properties.** { *; }

# Keep Ditto environment classes
-keep class live.ditto.environment.** { *; }

# Keep Ditto system classes
-keep class live.ditto.system.** { *; }

# Keep Ditto platform classes
-keep class live.ditto.platform.** { *; }

# Keep Ditto os classes
-keep class live.ditto.os.** { *; }

# Keep Ditto arch classes
-keep class live.ditto.arch.** { *; }

# Keep Ditto version classes
-keep class live.ditto.version.** { *; }

# Keep Ditto build classes
-keep class live.ditto.build.** { *; }

# Keep Ditto info classes
-keep class live.ditto.info.** { *; }

# Keep Ditto metadata classes
-keep class live.ditto.metadata.** { *; }

# Keep Ditto annotation classes
-keep class live.ditto.annotation.** { *; }

# Keep Ditto reflection classes
-keep class live.ditto.reflection.** { *; }

# Keep Ditto proxy classes
-keep class live.ditto.proxy.** { *; }

# Keep Ditto dynamic classes
-keep class live.ditto.dynamic.** { *; }

# Keep Ditto static classes
-keep class live.ditto.static.** { *; }

# Keep Ditto utility classes
-keep class live.ditto.util.** { *; }

# Keep Ditto helper classes
-keep class live.ditto.helper.** { *; }

# Keep Ditto tool classes
-keep class live.ditto.tool.** { *; }

# Keep Ditto test classes
-keep class live.ditto.test.** { *; }

# Keep Ditto mock classes
-keep class live.ditto.mock.** { *; }

# Keep Ditto stub classes
-keep class live.ditto.stub.** { *; }

# Keep Ditto spy classes
-keep class live.ditto.spy.** { *; }

# Keep Ditto fake classes
-keep class live.ditto.fake.** { *; }

# Keep Ditto fixture classes
-keep class live.ditto.fixture.** { *; }

# Keep Ditto factory classes
-keep class live.ditto.factory.** { *; }

# Keep Ditto data classes
-keep class live.ditto.data.** { *; }

# Keep Ditto model classes
-keep class live.ditto.model.** { *; }

# Keep Ditto entity classes
-keep class live.ditto.entity.** { *; }

# Keep Ditto dto classes
-keep class live.ditto.dto.** { *; }

# Keep Ditto vo classes
-keep class live.ditto.vo.** { *; }

# Keep Ditto pojo classes
-keep class live.ditto.pojo.** { *; }

# Keep Ditto bean classes
-keep class live.ditto.bean.** { *; }

# Keep Ditto record classes
-keep class live.ditto.record.** { *; }

# Keep Ditto case classes
-keep class live.ditto.case.** { *; }

# Keep Ditto enum classes
-keep class live.ditto.enum.** { *; }

# Keep Ditto constant classes
-keep class live.ditto.constant.** { *; }

# Keep Ditto exception classes
-keep class live.ditto.exception.** { *; }

# Keep Ditto error classes
-keep class live.ditto.error.** { *; }

# Keep Ditto warning classes
-keep class live.ditto.warning.** { *; }

# Keep Ditto info classes
-keep class live.ditto.info.** { *; }

# Keep Ditto debug classes
-keep class live.ditto.debug.** { *; }

# Keep Ditto trace classes
-keep class live.ditto.trace.** { *; }

# Keep Ditto log classes
-keep class live.ditto.log.** { *; }

# Keep Ditto logger classes
-keep class live.ditto.logger.** { *; }

# Keep Ditto level classes
-keep class live.ditto.level.** { *; }

# Keep Ditto formatter classes
-keep class live.ditto.formatter.** { *; }

# Keep Ditto appender classes
-keep class live.ditto.appender.** { *; }

# Keep Ditto layout classes
-keep class live.ditto.layout.** { *; }

# Keep Ditto pattern classes
-keep class live.ditto.pattern.** { *; }

# Keep Ditto marker classes
-keep class live.ditto.marker.** { *; }

# Keep Ditto mdc classes
-keep class live.ditto.mdc.** { *; }

# Keep Ditto ndc classes
-keep class live.ditto.ndc.** { *; }

# Keep Ditto thread context classes
-keep class live.ditto.thread_context.** { *; }

# Keep Ditto diagnostic classes
-keep class live.ditto.diagnostic.** { *; }

# Keep Ditto monitoring classes
-keep class live.ditto.monitoring.** { *; }

# Keep Ditto metrics classes
-keep class live.ditto.metrics.** { *; }

# Keep Ditto health classes
-keep class live.ditto.health.** { *; }

# Keep Ditto status classes
-keep class live.ditto.status.** { *; }

# Keep Ditto check classes
-keep class live.ditto.check.** { *; }

# Keep Ditto probe classes
-keep class live.ditto.probe.** { *; }

# Keep Ditto actuator classes
-keep class live.ditto.actuator.** { *; }

# Keep Ditto endpoint classes
-keep class live.ditto.endpoint.** { *; }

# Keep Ditto management classes
-keep class live.ditto.management.** { *; }

# Keep Ditto admin classes
-keep class live.ditto.admin.** { *; }

# Keep Ditto operation classes
-keep class live.ditto.operation.** { *; }

# Keep Ditto maintenance classes
-keep class live.ditto.maintenance.** { *; }

# Keep Ditto backup classes
-keep class live.ditto.backup.** { *; }

# Keep Ditto restore classes
-keep class live.ditto.restore.** { *; }

# Keep Ditto migration classes
-keep class live.ditto.migration.** { *; }

# Keep Ditto upgrade classes
-keep class live.ditto.upgrade.** { *; }

# Keep Ditto downgrade classes
-keep class live.ditto.downgrade.** { *; }

# Keep Ditto rollback classes
-keep class live.ditto.rollback.** { *; }

# Keep Ditto schema classes
-keep class live.ditto.schema.** { *; }

# Keep Ditto table classes
-keep class live.ditto.table.** { *; }

# Keep Ditto column classes
-keep class live.ditto.column.** { *; }

# Keep Ditto index classes
-keep class live.ditto.index.** { *; }

# Keep Ditto constraint classes
-keep class live.ditto.constraint.** { *; }

# Keep Ditto trigger classes
-keep class live.ditto.trigger.** { *; }

# Keep Ditto view classes
-keep class live.ditto.view.** { *; }

# Keep Ditto function classes
-keep class live.ditto.function.** { *; }

# Keep Ditto procedure classes
-keep class live.ditto.procedure.** { *; }

# Keep Ditto package classes
-keep class live.ditto.package.** { *; }

# Keep Ditto sequence classes
-keep class live.ditto.sequence.** { *; }

# Keep Ditto synonym classes
-keep class live.ditto.synonym.** { *; }

# Keep Ditto link classes
-keep class live.ditto.link.** { *; }

# Keep Ditto directory classes
-keep class live.ditto.directory.** { *; }

# Keep Ditto file classes
-keep class live.ditto.file.** { *; }

# Keep Ditto lob classes
-keep class live.ditto.lob.** { *; }

# Keep Ditto xml classes
-keep class live.ditto.xml.** { *; }

# Keep Ditto json classes
-keep class live.ditto.json.** { *; }

# Keep Ditto yaml classes
-keep class live.ditto.yaml.** { *; }

# Keep Ditto csv classes
-keep class live.ditto.csv.** { *; }

# Keep Ditto sql classes
-keep class live.ditto.sql.** { *; }

# Keep Ditto nosql classes
-keep class live.ditto.nosql.** { *; }

# Keep Ditto cache classes
-keep class live.ditto.cache.** { *; }

# Keep Ditto queue classes
-keep class live.ditto.queue.** { *; }

# Keep Ditto topic classes
-keep class live.ditto.topic.** { *; }

# Keep Ditto stream classes
-keep class live.ditto.stream.** { *; }

# Keep Ditto pipeline classes
-keep class live.ditto.pipeline.** { *; }

# Keep Ditto workflow classes
-keep class live.ditto.workflow.** { *; }

# Keep Ditto job classes
-keep class live.ditto.job.** { *; }

# Keep Ditto task classes
-keep class live.ditto.task.** { *; }

# Keep Ditto schedule classes
-keep class live.ditto.schedule.** { *; }

# Keep Ditto timer classes
-keep class live.ditto.timer.** { *; }

# Keep Ditto cron classes
-keep class live.ditto.cron.** { *; }

# Keep Ditto calendar classes
-keep class live.ditto.calendar.** { *; }

# Keep Ditto event classes
-keep class live.ditto.event.** { *; }

# Keep Ditto notification classes
-keep class live.ditto.notification.** { *; }

# Keep Ditto alert classes
-keep class live.ditto.alert.** { *; }

# Keep Ditto email classes
-keep class live.ditto.email.** { *; }

# Keep Ditto sms classes
-keep class live.ditto.sms.** { *; }

# Keep Ditto push classes
-keep class live.ditto.push.** { *; }

# Keep Ditto webhook classes
-keep class live.ditto.webhook.** { *; }

# Keep Ditto api classes
-keep class live.ditto.api.** { *; }

# Keep Ditto rest classes
-keep class live.ditto.rest.** { *; }

# Keep Ditto graphql classes
-keep class live.ditto.graphql.** { *; }

# Keep Ditto grpc classes
-keep class live.ditto.grpc.** { *; }

# Keep Ditto websocket classes
-keep class live.ditto.websocket.** { *; }

# Keep Ditto mqtt classes
-keep class live.ditto.mqtt.** { *; }

# Keep Ditto amqp classes
-keep class live.ditto.amqp.** { *; }

# Keep Ditto kafka classes
-keep class live.ditto.kafka.** { *; }

# Keep Ditto rabbitmq classes
-keep class live.ditto.rabbitmq.** { *; }

# Keep Ditto redis classes
-keep class live.ditto.redis.** { *; }

# Keep Ditto mongodb classes
-keep class live.ditto.mongodb.** { *; }

# Keep Ditto cassandra classes
-keep class live.ditto.cassandra.** { *; }

# Keep Ditto elasticsearch classes
-keep class live.ditto.elasticsearch.** { *; }

# Keep Ditto solr classes
-keep class live.ditto.solr.** { *; }

# Keep Ditto hbase classes
-keep class live.ditto.hbase.** { *; }

# Keep Ditto hdfs classes
-keep class live.ditto.hdfs.** { *; }

# Keep Ditto s3 classes
-keep class live.ditto.s3.** { *; }

# Keep Ditto gcs classes
-keep class live.ditto.gcs.** { *; }

# Keep Ditto azure classes
-keep class live.ditto.azure.** { *; }

# Keep Ditto aws classes
-keep class live.ditto.aws.** { *; }

# Keep Ditto gcp classes
-keep class live.ditto.gcp.** { *; }

# Keep Ditto docker classes
-keep class live.ditto.docker.** { *; }

# Keep Ditto kubernetes classes
-keep class live.ditto.kubernetes.** { *; }

# Keep Ditto helm classes
-keep class live.ditto.helm.** { *; }

# Keep Ditto terraform classes
-keep class live.ditto.terraform.** { *; }

# Keep Ditto ansible classes
-keep class live.ditto.ansible.** { *; }

# Keep Ditto puppet classes
-keep class live.ditto.puppet.** { *; }

# Keep Ditto chef classes
-keep class live.ditto.chef.** { *; }

# Keep Ditto salt classes
-keep class live.ditto.salt.** { *; }

# Keep Ditto jenkins classes
-keep class live.ditto.jenkins.** { *; }

# Keep Ditto gitlab classes
-keep class live.ditto.gitlab.** { *; }

# Keep Ditto github classes
-keep class live.ditto.github.** { *; }

# Keep Ditto bitbucket classes
-keep class live.ditto.bitbucket.** { *; }

# Keep Ditto jira classes
-keep class live.ditto.jira.** { *; }

# Keep Ditto confluence classes
-keep class live.ditto.confluence.** { *; }

# Keep Ditto slack classes
-keep class live.ditto.slack.** { *; }

# Keep Ditto teams classes
-keep class live.ditto.teams.** { *; }

# Keep Ditto discord classes
-keep class live.ditto.discord.** { *; }

# Keep Ditto zoom classes
-keep class live.ditto.zoom.** { *; }

# Keep Ditto meet classes
-keep class live.ditto.meet.** { *; }

# Keep Ditto webex classes
-keep class live.ditto.webex.** { *; }

# Keep Ditto skype classes
-keep class live.ditto.skype.** { *; }

# Keep Ditto whatsapp classes
-keep class live.ditto.whatsapp.** { *; }

# Keep Ditto telegram classes
-keep class live.ditto.telegram.** { *; }

# Keep Ditto signal classes
-keep class live.ditto.signal.** { *; }

# Keep Ditto matrix classes
-keep class live.ditto.matrix.** { *; }

# Keep Ditto xmpp classes
-keep class live.ditto.xmpp.** { *; }

# Keep Ditto irc classes
-keep class live.ditto.irc.** { *; }

# Keep Ditto ftp classes
-keep class live.ditto.ftp.** { *; }

# Keep Ditto sftp classes
-keep class live.ditto.sftp.** { *; }

# Keep Ditto scp classes
-keep class live.ditto.scp.** { *; }

# Keep Ditto rsync classes
-keep class live.ditto.rsync.** { *; }

# Keep Ditto ssh classes
-keep class live.ditto.ssh.** { *; }

# Keep Ditto telnet classes
-keep class live.ditto.telnet.** { *; }

# Keep Ditto rdp classes
-keep class live.ditto.rdp.** { *; }

# Keep Ditto vnc classes
-keep class live.ditto.vnc.** { *; }

# Keep Ditto vpn classes
-keep class live.ditto.vpn.** { *; }

# Keep Ditto proxy classes
-keep class live.ditto.proxy.** { *; }

# Keep Ditto firewall classes
-keep class live.ditto.firewall.** { *; }

# Keep Ditto load balancer classes
-keep class live.ditto.load_balancer.** { *; }

# Keep Ditto reverse proxy classes
-keep class live.ditto.reverse_proxy.** { *; }

# Keep Ditto cdn classes
-keep class live.ditto.cdn.** { *; }

# Keep Ditto dns classes
-keep class live.ditto.dns.** { *; }

# Keep Ditto dhcp classes
-keep class live.ditto.dhcp.** { *; }

# Keep Ditto ntp classes
-keep class live.ditto.ntp.** { *; }

# Keep Ditto syslog classes
-keep class live.ditto.syslog.** { *; }

# Keep Ditto snmp classes
-keep class live.ditto.snmp.** { *; }

# Keep Ditto netflow classes
-keep class live.ditto.netflow.** { *; }

# Keep Ditto sflow classes
-keep class live.ditto.sflow.** { *; }

# Keep Ditto ipfix classes
-keep class live.ditto.ipfix.** { *; }

# Keep Ditto packet capture classes
-keep class live.ditto.packet_capture.** { *; }

# Keep Ditto network monitoring classes
-keep class live.ditto.network_monitoring.** { *; }

# Keep Ditto security classes
-keep class live.ditto.security.** { *; }

# Keep Ditto authentication classes
-keep class live.ditto.authentication.** { *; }

# Keep Ditto authorization classes
-keep class live.ditto.authorization.** { *; }

# Keep Ditto accounting classes
-keep class live.ditto.accounting.** { *; }

# Keep Ditto audit classes
-keep class live.ditto.audit.** { *; }

# Keep Ditto compliance classes
-keep class live.ditto.compliance.** { *; }

# Keep Ditto governance classes
-keep class live.ditto.governance.** { *; }

# Keep Ditto risk classes
-keep class live.ditto.risk.** { *; }

# Keep Ditto threat classes
-keep class live.ditto.threat.** { *; }

# Keep Ditto vulnerability classes
-keep class live.ditto.vulnerability.** { *; }

# Keep Ditto incident classes
-keep class live.ditto.incident.** { *; }

# Keep Ditto forensics classes
-keep class live.ditto.forensics.** { *; }

# Keep Ditto malware classes
-keep class live.ditto.malware.** { *; }

# Keep Ditto antivirus classes
-keep class live.ditto.antivirus.** { *; }

# Keep Ditto firewall classes
-keep class live.ditto.firewall.** { *; }

# Keep Ditto ids classes
-keep class live.ditto.ids.** { *; }

# Keep Ditto ips classes
-keep class live.ditto.ips.** { *; }

# Keep Ditto siem classes
-keep class live.ditto.siem.** { *; }

# Keep Ditto soa classes
-keep class live.ditto.soa.** { *; }

# Keep Ditto microservices classes
-keep class live.ditto.microservices.** { *; }

# Keep Ditto serverless classes
-keep class live.ditto.serverless.** { *; }

# Keep Ditto lambda classes
-keep class live.ditto.lambda.** { *; }

# Keep Ditto function classes
-keep class live.ditto.function.** { *; }

# Keep Ditto container classes
-keep class live.ditto.container.** { *; }

# Keep Ditto orchestration classes
-keep class live.ditto.orchestration.** { *; }

# Keep Ditto service mesh classes
-keep class live.ditto.service_mesh.** { *; }

# Keep Ditto istio classes
-keep class live.ditto.istio.** { *; }

# Keep Ditto envoy classes
-keep class live.ditto.envoy.** { *; }

# Keep Ditto linkerd classes
-keep class live.ditto.linkerd.** { *; }

# Keep Ditto consul classes
-keep class live.ditto.consul.** { *; }

# Keep Ditto etcd classes
-keep class live.ditto.etcd.** { *; }

# Keep Ditto zookeeper classes
-keep class live.ditto.zookeeper.** { *; }

# Keep Ditto eureka classes
-keep class live.ditto.eureka.** { *; }

# Keep Ditto nacos classes
-keep class live.ditto.nacos.** { *; }

# Keep Ditto apollo classes
-keep class live.ditto.apollo.** { *; }

# Keep Ditto config classes
-keep class live.ditto.config.** { *; }

# Keep Ditto discovery classes
-keep class live.ditto.discovery.** { *; }

# Keep Ditto registry classes
-keep class live.ditto.registry.** { *; }

# Keep Ditto gateway classes
-keep class live.ditto.gateway.** { *; }

# Keep Ditto router classes
-keep class live.ditto.router.** { *; }

# Keep Ditto filter classes
-keep class live.ditto.filter.** { *; }

# Keep Ditto rate limit classes
-keep class live.ditto.rate_limit.** { *; }

# Keep Ditto circuit breaker classes
-keep class live.ditto.circuit_breaker.** { *; }

# Keep Ditto retry classes
-keep class live.ditto.retry.** { *; }

# Keep Ditto timeout classes
-keep class live.ditto.timeout.** { *; }

# Keep Ditto bulkhead classes
-keep class live.ditto.bulkhead.** { *; }

# Keep Ditto cache classes
-keep class live.ditto.cache.** { *; }

# Keep Ditto session classes
-keep class live.ditto.session.** { *; }

# Keep Ditto cookie classes
-keep class live.ditto.cookie.** { *; }

# Keep Ditto jwt classes
-keep class live.ditto.jwt.** { *; }

# Keep Ditto oauth classes
-keep class live.ditto.oauth.** { *; }

# Keep Ditto saml classes
-keep class live.ditto.saml.** { *; }

# Keep Ditto ldap classes
-keep class live.ditto.ldap.** { *; }

# Keep Ditto kerberos classes
-keep class live.ditto.kerberos.** { *; }

# Keep Ditto radius classes
-keep class live.ditto.radius.** { *; }

# Keep Ditto tacacs classes
-keep class live.ditto.tacacs.** { *; }

# Keep Ditto database classes
-keep class live.ditto.database.** { *; }

# Keep Ditto orm classes
-keep class live.ditto.orm.** { *; }

# Keep Ditto jpa classes
-keep class live.ditto.jpa.** { *; }

# Keep Ditto hibernate classes
-keep class live.ditto.hibernate.** { *; }

# Keep Ditto mybatis classes
-keep class live.ditto.mybatis.** { *; }

# Keep Ditto jdbctemplate classes
-keep class live.ditto.jdbctemplate.** { *; }

# Keep Ditto jooq classes
-keep class live.ditto.jooq.** { *; }

# Keep Ditto exposed classes
-keep class live.ditto.exposed.** { *; }

# Keep Ditto flyway classes
-keep class live.ditto.flyway.** { *; }

# Keep Ditto liquibase classes
-keep class live.ditto.liquibase.** { *; }

# Keep Ditto elasticsearch classes
-keep class live.ditto.elasticsearch.** { *; }

# Keep Ditto logstash classes
-keep class live.ditto.logstash.** { *; }

# Keep Ditto kibana classes
-keep class live.ditto.kibana.** { *; }

# Keep Ditto beats classes
-keep class live.ditto.beats.** { *; }

# Keep Ditto prometheus classes
-keep class live.ditto.prometheus.** { *; }

# Keep Ditto grafana classes
-keep class live.ditto.grafana.** { *; }

# Keep Ditto jaeger classes
-keep class live.ditto.jaeger.** { *; }

# Keep Ditto zipkin classes
-keep class live.ditto.zipkin.** { *; }

# Keep Ditto opentracing classes
-keep class live.ditto.opentracing.** { *; }

# Keep Ditto opencensus classes
-keep class live.ditto.opencensus.** { *; }

# Keep Ditto opentelemetry classes
-keep class live.ditto.opentelemetry.** { *; }

# Keep Ditto micrometer classes
-keep class live.ditto.micrometer.** { *; }

# Keep Ditto dropwizard classes
-keep class live.ditto.dropwizard.** { *; }

# Keep Ditto actuator classes
-keep class live.ditto.actuator.** { *; }

# Keep Ditto management classes
-keep class live.ditto.management.** { *; }

# Keep Ditto jmx classes
-keep class live.ditto.jmx.** { *; }

# Keep Ditto jolokia classes
-keep class live.ditto.jolokia.** { *; }

# Keep Ditto hawtio classes
-keep class live.ditto.hawtio.** { *; }

# Keep Ditto camel classes
-keep class live.ditto.camel.** { *; }

# Keep Ditto activemq classes
-keep class live.ditto.activemq.** { *; }

# Keep Ditto artemis classes
-keep class live.ditto.artemis.** { *; }

# Keep Ditto rabbitmq classes
-keep class live.ditto.rabbitmq.** { *; }

# Keep Ditto kafka classes
-keep class live.ditto.kafka.** { *; }

# Keep Ditto pulsar classes
-keep class live.ditto.pulsar.** { *; }

# Keep Ditto nats classes
-keep class live.ditto.nats.** { *; }

# Keep Ditto redis classes
-keep class live.ditto.redis.** { *; }

# Keep Ditto memcached classes
-keep class live.ditto.memcached.** { *; }

# Keep Ditto hazelcast classes
-keep class live.ditto.hazelcast.** { *; }

# Keep Ditto ignite classes
-keep class live.ditto.ignite.** { *; }

# Keep Ditto infinispan classes
-keep class live.ditto.infinispan.** { *; }

# Keep Ditto coherence classes
-keep class live.ditto.coherence.** { *; }

# Keep Ditto gemfire classes
-keep class live.ditto.gemfire.** { *; }

# Keep Ditto terracotta classes
-keep class live.ditto.terracotta.** { *; }

# Keep Ditto ehcache classes
-keep class live.ditto.ehcache.** { *; }

# Keep Ditto caffeine classes
-keep class live.ditto.caffeine.** { *; }

# Keep Ditto guava classes
-keep class live.ditto.guava.** { *; }

# Keep Ditto concurrentlinkedhashmap classes
-keep class live.ditto.concurrentlinkedhashmap.** { *; }

# Keep Ditto offheap classes
-keep class live.ditto.offheap.** { *; }

# Keep Ditto bigmemory classes
-keep class live.ditto.bigmemory.** { *; }

# Keep Ditto chronicle classes
-keep class live.ditto.chronicle.** { *; }

# Keep Ditto mapdb classes
-keep class live.ditto.mapdb.** { *; }

# Keep Ditto leveldb classes
-keep class live.ditto.leveldb.** { *; }

# Keep Ditto rocksdb classes
-keep class live.ditto.rocksdb.** { *; }

# Keep Ditto lmdb classes
-keep class live.ditto.lmdb.** { *; }

# Keep Ditto berkeleydb classes
-keep class live.ditto.berkeleydb.** { *; }

# Keep Ditto h2 classes
-keep class live.ditto.h2.** { *; }

# Keep Ditto hsqldb classes
-keep class live.ditto.hsqldb.** { *; }

# Keep Ditto derby classes
-keep class live.ditto.derby.** { *; }

# Keep Ditto sqlite classes
-keep class live.ditto.sqlite.** { *; }

# Keep Ditto postgresql classes
-keep class live.ditto.postgresql.** { *; }

# Keep Ditto mysql classes
-keep class live.ditto.mysql.** { *; }

# Keep Ditto mariadb classes
-keep class live.ditto.mariadb.** { *; }

# Keep Ditto oracle classes
-keep class live.ditto.oracle.** { *; }

# Keep Ditto sqlserver classes
-keep class live.ditto.sqlserver.** { *; }

# Keep Ditto db2 classes
-keep class live.ditto.db2.** { *; }

# Keep Ditto informix classes
-keep class live.ditto.informix.** { *; }

# Keep Ditto sybase classes
-keep class live.ditto.sybase.** { *; }

# Keep Ditto teradata classes
-keep class live.ditto.teradata.** { *; }

# Keep Ditto netezza classes
-keep class live.ditto.netezza.** { *; }

# Keep Ditto greenplum classes
-keep class live.ditto.greenplum.** { *; }

# Keep Ditto vertica classes
-keep class live.ditto.vertica.** { *; }

# Keep Ditto redshift classes
-keep class live.ditto.redshift.** { *; }

# Keep Ditto snowflake classes
-keep class live.ditto.snowflake.** { *; }

# Keep Ditto bigquery classes
-keep class live.ditto.bigquery.** { *; }

# Keep Ditto spanner classes
-keep class live.ditto.spanner.** { *; }

# Keep Ditto firestore classes
-keep class live.ditto.firestore.** { *; }

# Keep Ditto dynamodb classes
-keep class live.ditto.dynamodb.** { *; }

# Keep Ditto cosmosdb classes
-keep class live.ditto.cosmosdb.** { *; }

# Keep Ditto mongodb classes
-keep class live.ditto.mongodb.** { *; }

# Keep Ditto cassandra classes
-keep class live.ditto.cassandra.** { *; }

# Keep Ditto couchbase classes
-keep class live.ditto.couchbase.** { *; }

# Keep Ditto couchdb classes
-keep class live.ditto.couchdb.** { *; }

# Keep Ditto riak classes
-keep class live.ditto.riak.** { *; }

# Keep Ditto aerospike classes
-keep class live.ditto.aerospike.** { *; }

# Keep Ditto scylladb classes
-keep class live.ditto.scylladb.** { *; }

# Keep Ditto yugabytedb classes
-keep class live.ditto.yugabytedb.** { *; }

# Keep Ditto cockroachdb classes
-keep class live.ditto.cockroachdb.** { *; }

# Keep Ditto tidb classes
-keep class live.ditto.tidb.** { *; }

# Keep Ditto vitess classes
-keep class live.ditto.vitess.** { *; }

# Keep Ditto citus classes
-keep class live.ditto.citus.** { *; }

# Keep Ditto timescaledb classes
-keep class live.ditto.timescaledb.** { *; }

# Keep Ditto clickhouse classes
-keep class live.ditto.clickhouse.** { *; }

# Keep Ditto pinot classes
-keep class live.ditto.pinot.** { *; }

# Keep Ditto druid classes
-keep class live.ditto.druid.** { *; }

# Keep Ditto kudu classes
-keep class live.ditto.kudu.** { *; }

# Keep Ditto impala classes
-keep class live.ditto.impala.** { *; }

# Keep Ditto hive classes
-keep class live.ditto.hive.** { *; }

# Keep Ditto spark classes
-keep class live.ditto.spark.** { *; }

# Keep Ditto flink classes
-keep class live.ditto.flink.** { *; }

# Keep Ditto storm classes
-keep class live.ditto.storm.** { *; }

# Keep Ditto samza classes
-keep class live.ditto.samza.** { *; }

# Keep Ditto heron classes
-keep class live.ditto.heron.** { *; }

# Keep Ditto beam classes
-keep class live.ditto.beam.** { *; }

# Keep Ditto dataflow classes
-keep class live.ditto.dataflow.** { *; }

# Keep Ditto cloud dataflow classes
-keep class live.ditto.cloud_dataflow.** { *; }

# Keep Ditto composer classes
-keep class live.ditto.composer.** { *; }

# Keep Ditto dataproc classes
-keep class live.ditto.dataproc.** { *; }

# Keep Ditto data lab classes
-keep class live.ditto.data_lab.** { *; }

# Keep Ditto bigtable classes
-keep class live.ditto.bigtable.** { *; }

# Keep Ditto cloud storage classes
-keep class live.ditto.cloud_storage.** { *; }

# Keep Ditto cloud sql classes
-keep class live.ditto.cloud_sql.** { *; }

# Keep Ditto cloud spanner classes
-keep class live.ditto.cloud_spanner.** { *; }

# Keep Ditto cloud firestore classes
-keep class live.ditto.cloud_firestore.** { *; }

# Keep Ditto cloud bigtable classes
-keep class live.ditto.cloud_bigtable.** { *; }

# Keep Ditto cloud pubsub classes
-keep class live.ditto.cloud_pubsub.** { *; }

# Keep Ditto cloud functions classes
-keep class live.ditto.cloud_functions.** { *; }

# Keep Ditto cloud run classes
-keep class live.ditto.cloud_run.** { *; }

# Keep Ditto app engine classes
-keep class live.ditto.app_engine.** { *; }

# Keep Ditto kubernetes engine classes
-keep class live.ditto.kubernetes_engine.** { *; }

# Keep Ditto anthos classes
-keep class live.ditto.anthos.** { *; }

# Keep Ditto cloud build classes
-keep class live.ditto.cloud_build.** { *; }

# Keep Ditto cloud deploy classes
-keep class live.ditto.cloud_deploy.** { *; }

# Keep Ditto cloud logging classes
-keep class live.ditto.cloud_logging.** { *; }

# Keep Ditto cloud monitoring classes
-keep class live.ditto.cloud_monitoring.** { *; }

# Keep Ditto cloud trace classes
-keep class live.ditto.cloud_trace.** { *; }

# Keep Ditto cloud debugger classes
-keep class live.ditto.cloud_debugger.** { *; }

# Keep Ditto cloud profiler classes
-keep class live.ditto.cloud_profiler.** { *; }

# Keep Ditto cloud endpoints classes
-keep class live.ditto.cloud_endpoints.** { *; }

# Keep Ditto cloud tasks classes
-keep class live.ditto.cloud_tasks.** { *; }

# Keep Ditto cloud scheduler classes
-keep class live.ditto.cloud_scheduler.** { *; }

# Keep Ditto cloud iot classes
-keep class live.ditto.cloud_iot.** { *; }

# Keep Ditto cloud vision classes
-keep class live.ditto.cloud_vision.** { *; }

# Keep Ditto cloud speech classes
-keep class live.ditto.cloud_speech.** { *; }

# Keep Ditto cloud translate classes
-keep class live.ditto.cloud_translate.** { *; }

# Keep Ditto cloud language classes
-keep class live.ditto.cloud_language.** { *; }

# Keep Ditto cloud video intelligence classes
-keep class live.ditto.cloud_video_intelligence.** { *; }

# Keep Ditto cloud automl classes
-keep class live.ditto.cloud_automl.** { *; }

# Keep Ditto cloud natural language classes
-keep class live.ditto.cloud_natural_language.** { *; }

# Keep Ditto cloud text to speech classes
-keep class live.ditto.cloud_text_to_speech.** { *; }

# Keep Ditto cloud speech to text classes
-keep class live.ditto.cloud_speech_to_text.** { *; }

# Keep Ditto cloud dialogflow classes
-keep class live.ditto.cloud_dialogflow.** { *; }

# Keep Ditto cloud recommendation classes
-keep class live.ditto.cloud_recommendation.** { *; }

# Keep Ditto cloud retail classes
-keep class live.ditto.cloud_retail.** { *; }

# Keep Ditto cloud healthcare classes
-keep class live.ditto.cloud_healthcare.** { *; }

# Keep Ditto cloud life sciences classes
-keep class live.ditto.cloud_life_sciences.** { *; }

# Keep Ditto cloud talent solution classes
-keep class live.ditto.cloud_talent_solution.** { *; }

# Keep Ditto cloud web security scanner classes
-keep class live.ditto.cloud_web_security_scanner.** { *; }

# Keep Ditto cloud security command center classes
-keep class live.ditto.cloud_security_command_center.** { *; }

# Keep Ditto cloud asset inventory classes
-keep class live.ditto.cloud_asset_inventory.** { *; }

# Keep Ditto cloud data loss prevention classes
-keep class live.ditto.cloud_data_loss_prevention.** { *; }

# Keep Ditto cloud identity aware proxy classes
-keep class live.ditto.cloud_identity_aware_proxy.** { *; }

# Keep Ditto cloud identity platform classes
-keep class live.ditto.cloud_identity_platform.** { *; }

# Keep Ditto cloud resource manager classes
-keep class live.ditto.cloud_resource_manager.** { *; }

# Keep Ditto cloud billing classes
-keep class live.ditto.cloud_billing.** { *; }

# Keep Ditto cloud support classes
-keep class live.ditto.cloud_support.** { *; }

# Keep Ditto cloud marketplace classes
-keep class live.ditto.cloud_marketplace.** { *; }

# Keep Ditto cloud deployment manager classes
-keep class live.ditto.cloud_deployment_manager.** { *; }

# Keep Ditto cloud service management classes
-keep class live.ditto.cloud_service_management.** { *; }

# Keep Ditto cloud service control classes
-keep class live.ditto.cloud_service_control.** { *; }

# Keep Ditto cloud binary authorization classes
-keep class live.ditto.cloud_binary_authorization.** { *; }

# Keep Ditto cloud container analysis classes
-keep class live.ditto.cloud_container_analysis.** { *; }

# Keep Ditto cloud security scanner classes
-keep class live.ditto.cloud_security_scanner.** { *; }

# Keep Ditto cloud error reporting classes
-keep class live.ditto.cloud_error_reporting.** { *; }

# Keep Ditto cloud logging classes
-keep class live.ditto.cloud_logging.** { *; }

# Keep Ditto cloud monitoring classes
-keep class live.ditto.cloud_monitoring.** { *; }

# Keep Ditto cloud trace classes
-keep class live.ditto.cloud_trace.** { *; }

# Keep Ditto cloud debugger classes
-keep class live.ditto.cloud_debugger.** { *; }

# Keep Ditto cloud profiler classes
-keep class live.ditto.cloud_profiler.** { *; }

# Keep Ditto cloud endpoints classes
-keep class live.ditto.cloud_endpoints.** { *; }

# Keep Ditto cloud tasks classes
-keep class live.ditto.cloud_tasks.** { *; }

# Keep Ditto cloud scheduler classes
-keep class live.ditto.cloud_scheduler.** { *; }

# Keep Ditto cloud iot classes
-keep class live.ditto.cloud_iot.** { *; }

# Keep Ditto cloud vision classes
-keep class live.ditto.cloud_vision.** { *; }

# Keep Ditto cloud speech classes
-keep class live.ditto.cloud_speech.** { *; }

# Keep Ditto cloud translate classes
-keep class live.ditto.cloud_translate.** { *; }

# Keep Ditto cloud language classes
-keep class live.ditto.cloud_language.** { *; }

# Keep Ditto cloud video intelligence classes
-keep class live.ditto.cloud_video_intelligence.** { *; }

# Keep Ditto cloud automl classes
-keep class live.ditto.cloud_automl.** { *; }

# Keep Ditto cloud natural language classes
-keep class live.ditto.cloud_natural_language.** { *; }

# Keep Ditto cloud text to speech classes
-keep class live.ditto.cloud_text_to_speech.** { *; }

# Keep Ditto cloud speech to text classes
-keep class live.ditto.cloud_speech_to_text.** { *; }

# Keep Ditto cloud dialogflow classes
-keep class live.ditto.cloud_dialogflow.** { *; }

# Keep Ditto cloud recommendation classes
-keep class live.ditto.cloud_recommendation.** { *; }

# Keep Ditto cloud retail classes
-keep class live.ditto.cloud_retail.** { *; }

# Keep Ditto cloud healthcare classes
-keep class live.ditto.cloud_healthcare.** { *; }

# Keep Ditto cloud life sciences classes
-keep class live.ditto.cloud_life_sciences.** { *; }

# Keep Ditto cloud talent solution classes
-keep class live.ditto.cloud_talent_solution.** { *; }

# Keep Ditto cloud web security scanner classes
-keep class live.ditto.cloud_web_security_scanner.** { *; }

# Keep Ditto cloud security command center classes
-keep class live.ditto.cloud_security_command_center.** { *; }

# Keep Ditto cloud asset inventory classes
-keep class live.ditto.cloud_asset_inventory.** { *; }

# Keep Ditto cloud data loss prevention classes
-keep class live.ditto.cloud_data_loss_prevention.** { *; }

# Keep Ditto cloud identity aware proxy classes
-keep class live.ditto.cloud_identity_aware_proxy.** { *; }

# Keep Ditto cloud identity platform classes
-keep class live.ditto.cloud_identity_platform.** { *; }

# Keep Ditto cloud resource manager classes
-keep class live.ditto.cloud_resource_manager.** { *; }

# Keep Ditto cloud billing classes
-keep class live.ditto.cloud_billing.** { *; }

# Keep Ditto cloud support classes
-keep class live.ditto.cloud_support.** { *; }

# Keep Ditto cloud marketplace classes
-keep class live.ditto.cloud_marketplace.** { *; }

# Keep Ditto cloud deployment manager classes
-keep class live.ditto.cloud_deployment_manager.** { *; }

# Keep Ditto cloud service management classes
-keep class live.ditto.cloud_service_management.** { *; }

# Keep Ditto cloud service control classes
-keep class live.ditto.cloud_service_control.** { *; }

# Keep Ditto cloud binary authorization classes
-keep class live.ditto.cloud_binary_authorization.** { *; }

# Keep Ditto cloud container analysis classes
-keep class live.ditto.cloud_container_analysis.** { *; }

# Keep Ditto cloud security scanner classes
-keep class live.ditto.cloud_security_scanner.** { *; }

# Keep Ditto cloud error reporting classes
-keep class live.ditto.cloud_error_reporting.** { *; }

# Keep Ditto cloud logging classes
-keep class live.ditto.cloud_logging.** { *; }

# Keep Ditto cloud monitoring classes
-keep class live.ditto.cloud_monitoring.** { *; }

# Keep Ditto cloud trace classes
-keep class live.ditto.cloud_trace.** { *; }

# Keep Ditto cloud debugger classes
-keep class live.ditto.cloud_debugger.** { *; }

# Keep Ditto cloud profiler classes
-keep class live.ditto.cloud_profiler.** { *; }

# Keep Ditto cloud endpoints classes
-keep class live.ditto.cloud_endpoints.** { *; }

# Keep Ditto cloud tasks classes
-keep class live.ditto.cloud_tasks.** { *; }

# Keep Ditto cloud scheduler classes
-keep class live.ditto.cloud_scheduler.** { *; }

# Keep Ditto cloud iot classes
-keep class live.ditto.cloud_iot.** { *; }

# Keep Ditto cloud vision classes
-keep class live.ditto.cloud_vision.** { *; }

# Keep Ditto cloud speech classes
-keep class live.ditto.cloud_speech.** { *; }

# Keep Ditto cloud translate classes
-keep class live.ditto.cloud_translate.** { *; }

# Keep Ditto cloud language classes
-keep class live.ditto.cloud_language.** { *; }

# Keep Ditto cloud video intelligence classes
-keep class live.ditto.cloud_video_intelligence.** { *; }

# Keep Ditto cloud automl classes
-keep class live.ditto.cloud_automl.** { *; }

# Keep Ditto cloud natural language classes
-keep class live.ditto.cloud_natural_language.** { *; }

# Keep Ditto cloud text to speech classes
-keep class live.ditto.cloud_text_to_speech.** { *; }

# Keep Ditto cloud speech to text classes
-keep class live.ditto.cloud_speech_to_text.** { *; }

# Keep Ditto cloud dialogflow classes
-keep class live.ditto.cloud_dialogflow.** { *; }

# Keep Ditto cloud recommendation classes
-keep class live.ditto.cloud_recommendation.** { *; }

# Keep Ditto cloud retail classes
-keep class live.ditto.cloud_retail.** { *; }

# Keep Ditto cloud healthcare classes
-keep class live.ditto.cloud_healthcare.** { *; }

# Keep Ditto cloud life sciences classes
-keep class live.ditto.cloud_life_sciences.** { *; }

# Keep Ditto cloud talent solution classes
-keep class live.ditto.cloud_talent_solution.** { *; }

# Keep Ditto cloud web security scanner classes
-keep class live.ditto.cloud_web_security_scanner.** { *; }

# Keep Ditto cloud security command center classes
-keep class live.ditto.cloud_security_command_center.** { *; }

# Keep Ditto cloud asset inventory classes
-keep class live.ditto.cloud_asset_inventory.** { *; }

# Keep Ditto cloud data loss prevention classes
-keep class live.ditto.cloud_data_loss_prevention.** { *; }

# Keep Ditto cloud identity aware proxy classes
-keep class live.ditto.cloud_identity_aware_proxy.** { *; }

# Keep Ditto cloud identity platform classes
-keep class live.ditto.cloud_identity_platform.** { *; }

# Keep Ditto cloud resource manager classes
-keep class live.ditto.cloud_resource_manager.** { *; }

# Keep Ditto cloud billing classes
-keep class live.ditto.cloud_billing.** { *; }

# Keep Ditto cloud support classes
-keep class live.ditto.cloud_support.** { *; }

# Keep Ditto cloud marketplace classes
-keep class live.ditto.cloud_marketplace.** { *; }

# Keep Ditto cloud deployment manager classes
-keep class live.ditto.cloud_deployment_manager.** { *; }

# Keep Ditto cloud service management classes
-keep class live.ditto.cloud_service_management.** { *; }

# Keep Ditto cloud service control classes
-keep class live.ditto.cloud_service_control.** { *; }

# Keep Ditto cloud binary authorization classes
-keep class live.ditto.cloud_binary_authorization.** { *; }

# Keep Ditto cloud container analysis classes
-keep class live.ditto.cloud_container_analysis.** { *; }

# Keep Ditto cloud security scanner classes
-keep class live.ditto.cloud_security_scanner.** { *; }

# Keep Ditto cloud error reporting classes
-keep class live.ditto.cloud_error_reporting.** { *; }

# Keep Ditto cloud logging classes
-keep class live.ditto.cloud_logging.** { *; }

# Keep Ditto cloud monitoring classes
-keep class live.ditto.cloud_monitoring.** { *; }

# Keep Ditto cloud trace classes
-keep class live.ditto.cloud_trace.** { *; }

# Keep Ditto cloud debugger classes
-keep class live.ditto.cloud_debugger.** { *; }

# Keep Ditto cloud profiler classes
-keep class live.ditto.cloud_profiler.** { *; }

# Keep Ditto cloud endpoints classes
-keep class live.ditto.cloud_endpoints.** { *; }

# Keep Ditto cloud tasks classes
-keep class live.ditto.cloud_tasks.** { *; }

# Keep Ditto cloud scheduler classes
-keep class live.ditto.cloud_scheduler.** { *; }

# Keep Ditto cloud iot classes
-keep class live.ditto.cloud_iot.** { *; }

# Keep Ditto cloud vision classes
-keep class live.ditto.cloud_vision.** { *; }

# Keep Ditto cloud speech classes
-keep class live.ditto.cloud_speech.** { *; }

# Keep Ditto cloud translate classes
-keep class live.ditto.cloud_translate.** { *; }

# Keep Ditto cloud language classes
-keep class live.ditto.cloud_language.** { *; }

# Keep Ditto cloud video intelligence classes
-keep class live.ditto.cloud_video_intelligence.** { *; }

# Keep Ditto cloud automl classes
-keep class live.ditto.cloud_automl.** { *; }

# Keep Ditto cloud natural language classes
-keep class live.ditto.cloud_natural_language.** { *; }

# Keep Ditto cloud text to speech classes
-keep class live.ditto.cloud_text_to_speech.** { *; }

# Keep Ditto cloud speech to text classes
-keep class live.ditto.cloud_speech_to_text.** { *; }

# Keep Ditto cloud dialogflow classes
-keep class live.ditto.cloud_dialogflow.** { *; }

# Keep Ditto cloud recommendation classes
-keep class live.ditto.cloud_recommendation.** { *; }

# Keep Ditto cloud retail classes
-keep class live.ditto.cloud_retail.** { *; }

# Keep Ditto cloud healthcare classes
-keep class live.ditto.cloud_healthcare.** { *; }

# Keep Ditto cloud life sciences classes
-keep class live.ditto.cloud_life_sciences.** { *; }

# Keep Ditto cloud talent solution classes
-keep class live.ditto.cloud_talent_solution.** { *; }

# Keep Ditto cloud web security scanner classes
-keep class live.ditto.cloud_web_security_scanner.** { *; }

# Keep Ditto cloud security command center classes
-keep class live.ditto.cloud_security_command_center.** { *; }

# Keep Ditto cloud asset inventory classes
-keep class live.ditto.cloud_asset_inventory.** { *; }

# Keep Ditto cloud data loss prevention classes
-keep class live.ditto.cloud_data_loss_prevention.** { *; }

# Keep Ditto cloud identity aware proxy classes
-keep class live.ditto.cloud_identity_aware_proxy.** { *; }

# Keep Ditto cloud identity platform classes
-keep class live.ditto.cloud_identity_platform.** { *; }

# Keep Ditto cloud resource manager classes
-keep class live.ditto.cloud_resource_manager.** { *; }

# Keep Ditto cloud billing classes
-keep class live.ditto.cloud_billing.** { *; }

# Keep Ditto cloud support classes
-keep class live.ditto.cloud_support.** { *; }

# Keep Ditto cloud marketplace classes
-keep class live.ditto.cloud_marketplace.** { *; }

# Keep Ditto cloud deployment manager classes
-keep class live.ditto.cloud_deployment_manager.** { *; }

# Keep Ditto cloud service management classes
-keep class live.ditto.cloud_service_management.** { *; }

# Keep Ditto cloud service control classes
-keep class live.ditto.cloud_service_control.** { *; }

# Keep Ditto cloud binary authorization classes
-keep class live.ditto.cloud_binary_authorization.** { *; }

# Keep Ditto cloud container analysis classes
-keep class live.ditto.cloud_container_analysis.** { *; }

# Keep Ditto cloud security scanner classes
-keep class live.ditto.cloud_security_scanner.** { *; }

# Keep Ditto cloud error reporting classes
-keep class live.ditto.cloud_error_reporting.** { *; }

# Keep Ditto cloud logging classes
-keep class live.ditto.cloud_logging.** { *; }

# Keep Ditto cloud monitoring classes
-keep class live.ditto.cloud_monitoring.** { *; }

# Keep Ditto cloud trace classes
-keep class live.ditto.cloud_trace.** { *; }

# Keep Ditto cloud debugger classes
-keep class live.ditto.cloud_debugger.** { *; }

# Keep Ditto cloud profiler classes
-keep class live.ditto.cloud_profiler.** { *; }

# Keep Ditto cloud endpoints classes
-keep class live.ditto.cloud_endpoints.** { *; }

# Keep Ditto cloud tasks classes
-keep class live.ditto.cloud_tasks.** { *; }

# Keep Ditto cloud scheduler classes
-keep class live.ditto.cloud_scheduler.** { *; }

# Keep Ditto cloud iot classes
-keep class live.ditto.cloud_iot.** { *; }

# Keep Ditto cloud vision classes
-keep class live.ditto.cloud_vision.** { *; }

# Keep Ditto cloud speech classes
-keep class live.ditto.cloud_speech.** { *; }

# Keep Ditto cloud translate classes
-keep class live.ditto.cloud_translate.** { *; }

# Keep Ditto cloud language classes
-keep class live.ditto.cloud_language.** { *; }

# Keep Ditto cloud video intelligence classes
-keep class live.ditto.cloud_video_intelligence.** { *; }

# Keep Ditto cloud automl classes
-keep class live.ditto.cloud_automl.** { *; }

# Keep Ditto cloud natural language classes
-keep class live.ditto.cloud_natural_language.** { *; }

# Keep Ditto cloud text to speech classes
-keep class live.ditto.cloud_text_to_speech.** { *; }

# Keep Ditto cloud speech to text classes
-keep class live.ditto.cloud_speech_to_text.** { *; }

# Keep Ditto cloud dialogflow classes
-keep class live.ditto.cloud_dialogflow.** { *; }

# Keep Ditto cloud recommendation classes
-keep class live.ditto.cloud_recommendation.** { *; }

# Keep Ditto cloud retail classes
-keep class live.ditto.cloud_retail.** { *; }

# Keep Ditto cloud healthcare classes
-keep class live.ditto.cloud_healthcare.** { *; }

# Keep Ditto cloud life sciences classes
-keep class live.ditto.cloud_life_sciences.** { *; }

# Keep Ditto cloud talent solution classes
-keep class live.ditto.cloud_talent_solution.** { *; }

# Keep Ditto cloud web security scanner classes
-keep class live.ditto.cloud_web_security_scanner.** { *; }

# Keep Ditto cloud security command center classes
-keep class live.ditto.cloud_security_command_center.** { *; }

# Keep Ditto cloud asset inventory classes
-keep class live.ditto.cloud_asset_inventory.** { *; }

# Keep Ditto cloud data loss prevention classes
-keep class live.ditto.cloud_data_loss_prevention.** { *; }

# Keep Ditto cloud identity aware proxy classes
-keep class live.ditto.cloud_identity_aware_proxy.** { *; }

# Keep Ditto cloud identity platform classes
-keep class live.ditto.cloud_identity_platform.** { *; }

# Keep Ditto cloud resource manager classes
-keep class live.ditto.cloud_resource_manager.** { *; }

# Keep Ditto cloud billing classes
-keep class live.ditto.cloud_billing.** { *; }

# Keep Ditto cloud support classes
-keep class live.ditto.cloud_support.** { *; }

# Keep Ditto cloud marketplace classes
-keep class live.ditto.cloud_marketplace.** { *; }

# Keep Ditto cloud deployment manager classes
-keep class live.ditto.cloud_deployment_manager.** { *; }

# Keep Ditto cloud service management classes
-keep class live.ditto.cloud_service_management.** { *; }

# Keep Ditto cloud service control classes
-keep class live.ditto.cloud_service_control.** { *; }

# Keep Ditto cloud binary authorization classes
-keep class live.ditto.cloud_binary_authorization.** { *; }

# Keep Ditto cloud container analysis classes
-keep class live.ditto.cloud_container_analysis.** { *; }

# Keep Ditto cloud security scanner classes
-keep class live.ditto.cloud_security_scanner.** { *; }

# Keep Ditto cloud error reporting classes
-keep class live.ditto.cloud_error_reporting.** { *; }

# Keep Ditto cloud logging classes
-keep class live.ditto.cloud_logging.** { *; }

# Keep Ditto cloud monitoring classes
-keep class live.ditto.cloud_monitoring.** { *; }

# Keep Ditto cloud trace classes
-keep class live.ditto.cloud_trace.** { *; }

# Keep Ditto cloud debugger classes
-keep class live.ditto.cloud_debugger.** { *; }

# Keep Ditto cloud profiler classes
-keep class live.ditto.cloud_profiler.** { *; }

# Keep Ditto cloud endpoints classes
-keep class live.ditto.cloud_endpoints.** { *; }

# Keep Ditto cloud tasks classes
-keep class live.ditto.cloud_tasks.** { *; }

# Keep Ditto cloud scheduler classes
-keep class live.ditto.cloud_scheduler.** { *; }

# Keep Ditto cloud iot classes
-keep class live.ditto.cloud_iot.** { *; }

# Keep Ditto cloud vision classes
-keep class live.ditto.cloud_vision.** { *; }

# Keep Ditto cloud speech classes
-keep class live.ditto.cloud_speech.** { *; }

# Keep Ditto cloud translate classes
-keep class live.ditto.cloud_translate.** { *; }

# Keep Ditto cloud language classes
-keep class live.ditto.cloud_language.** { *; }

# Keep Ditto cloud video intelligence classes
-keep class live.ditto.cloud_video_intelligence.** { *; }

# Keep Ditto cloud automl classes
-keep class live.ditto.cloud_automl.** { *; }

# Keep Ditto cloud natural language classes
-keep class live.ditto.cloud_natural_language.** { *; }

# Keep Ditto cloud text to speech classes
-keep class live.ditto.cloud_text_to_speech.** { *; }

# Keep Ditto cloud speech to text classes
-keep class live.ditto.cloud_speech_to_text.** { *; }

# Keep Ditto cloud dialogflow classes
-keep class live.ditto.cloud_dialogflow.** { *; }

# Keep Ditto cloud recommendation classes
-keep class live.ditto.cloud_recommendation.** { *; }

# Keep Ditto cloud retail classes
-keep class live.ditto.cloud_retail.** { *; }

# Keep Ditto cloud healthcare classes
-keep class live.ditto.cloud_healthcare.** { *; }

# Keep Ditto cloud life sciences classes
-keep class live.ditto.cloud_life_sciences.** { *; }

# Keep Ditto cloud talent solution classes
-keep class live.ditto.cloud_talent_solution.** { *; }

# Keep Ditto cloud web security scanner classes
-keep class live.ditto.cloud_web_security_scanner.** { *; }

# Keep Ditto cloud security command center classes
-keep class live.ditto.cloud_security_command_center.** { *; }

# Keep Ditto cloud asset inventory classes
-keep class live.ditto.cloud_asset_inventory.** { *; }

# Keep Ditto cloud data loss prevention classes
-keep class live.ditto.cloud_data_loss_prevention.** { *; }

# Keep Ditto cloud identity aware proxy classes
-keep class live.ditto.cloud_identity_aware_proxy.** { *; }

# Keep Ditto cloud identity platform classes
-keep class live.ditto.cloud_identity_platform.** { *; }

# Keep Ditto cloud resource manager classes
-keep class live.ditto.cloud_resource_manager.** { *; }

# Keep Ditto cloud billing classes
-keep class live.ditto.cloud_billing.** { *; }

# Keep Ditto cloud support classes
-keep class live.ditto.cloud_support.** { *; }

# Keep Ditto cloud marketplace classes
-keep class live.ditto.cloud_marketplace.** { *; }

# Keep Ditto cloud deployment manager classes
-keep class live.ditto.cloud_deployment_manager.** { *; }

# Keep Ditto cloud service management classes
-keep class live.ditto.cloud_service_management.** { *; }

# Keep Ditto cloud service control classes
-keep class live.ditto.cloud_service_control.** { *; }

# Keep Ditto cloud binary authorization classes
-keep class live.ditto.cloud_binary_authorization.** { *; }

# Keep Ditto cloud container analysis classes
-keep class live.ditto.cloud_container_analysis.** { *; }

# Keep Ditto cloud security scanner classes
-keep class live.ditto.cloud_security_scanner.** { *; }

# Keep Ditto cloud error reporting classes
-keep class live.ditto.cloud_error_reporting.** { *; }

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.gms.auth.api.credentials.Credential$Builder
-dontwarn com.google.android.gms.auth.api.credentials.Credential
-dontwarn com.google.android.gms.auth.api.credentials.CredentialPickerConfig$Builder
-dontwarn com.google.android.gms.auth.api.credentials.CredentialPickerConfig
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequest$Builder
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequest
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequestResponse
-dontwarn com.google.android.gms.auth.api.credentials.Credentials
-dontwarn com.google.android.gms.auth.api.credentials.CredentialsClient
-dontwarn com.google.android.gms.auth.api.credentials.HintRequest$Builder
-dontwarn com.google.android.gms.auth.api.credentials.HintRequest