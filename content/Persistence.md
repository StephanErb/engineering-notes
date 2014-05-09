# Persistence

## Redis Persistence

The RDB persistence performs point-in-time snapshots of your dataset at specified intervals.
the AOF persistence logs every write operation received by the server, that will be played again at server startup, reconstructing the original dataset. Commands are logged using the same format as the Redis protocol itself, in an append-only fashion. Redis is able to rewrite the log on background when it gets too big.

RDB maximizes Redis performances
RDB is NOT good if you need to minimize the chance of data loss in case Redis stops working (for example after a power outage). You should be prepared to lose the latest minutes of data.

AOF Redis is much more durable: you can have different fsync policies: no fsync at all, fsync every second, fsync at every query. With the default policy of fsync every second write performances are still great (fsync is performed using a background thread and the main thread will try hard to perform writes when no fsync is in progress.) but you can only lose one second worth of writes.
AOF can be slower then RDB depending on the exact fsync policy.

The general indication is that you should use both persistence methods if you want a degree of data safety comparable to what PostgreSQL can provide you.

http://redis.io/topics/persistence



## ZeroMQ
ØMQ (also seen as ZeroMQ, 0MQ, zmq) looks like an embeddable networking library but acts like a concurrency framework. It gives you sockets that carry atomic messages across various transports like in-process, inter-process, TCP, and multicast. You can connect sockets N-to-N with patterns like fanout, pub-sub, task distribution, and request-reply. It’s fast enough to be the fabric for clustered products. Its asynchronous I/O model gives you scalable multi-core applications, built as asynchronous message-processing tasks.

ZeroMQ is a software library, that provides the building blocks for building things like pub-sub queues, rather than being an actual pub-sub queue or any other kind of network server itself.

You can design your network software to precisely match your own requirements, and all of the low-level details such as message buffering and routing strategies are all tucked away neatly in the software library.


## Message Queueing / AMQP
* Decouple master/worker. Flexible numbers of workers that can feed themselves
* The Advanced Message Queuing Protocol (AMQP) is an open standard application layer protocol for message-oriented middleware. The defining features of AMQP are message orientation, queuing, routing (including point-to-point and publish-and-subscribe), reliability and security.[1]



## Celery
* Task queues are used as a mechanism to distribute work across threads or machines.

A task queue's input is a unit of work, called a task, dedicated worker processes then constantly monitor the queue for new work to perform.

Celery communicates via messages, usually using a broker to mediate between clients and workers. To initiate a task a client puts a message on the queue, the broker then delivers the message to a worker.

A Celery system can consist of multiple workers and brokers, giving way to high availability and horizontal scalin

Celery is an asynchronous task queue/job queue based on distributed message passing.	It is focused on real-time operation, but supports scheduling as well.
The execution units, called tasks, are executed concurrently on a single or more worker servers using multiprocessing, Eventlet,	or gevent. Tasks can execute asynchronously (in the background) or synchronously (wait until ready).
