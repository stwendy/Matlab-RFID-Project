__author__ = 'zhangyanyi, Xinyu Li'


import csv
import tensorflow as tf
import numpy as np
import utils
import gc
# mnist = input_data.read_data_sets('MNIST_data', one_hot=True)


testSize=5000

class DataSet(object):
    def __init__(self, images, labels, fake_data=False):
        if fake_data:
            self._num_examples = 10000
        else:
            assert images.shape[0] == labels.shape[0], (
                "images.shape: %s labels.shape: %s" % (images.shape,
                                                       labels.shape))
            self._num_examples = images.shape[0]
            # Convert shape from [num examples, rows, columns, depth]
            # to [num examples, rows*columns] (assuming depth == 1)
            assert images.shape[3] == 1
            images = images.reshape(images.shape[0],
                                    images.shape[1] * images.shape[2])
            # Convert from [0, 255] -> [0.0, 1.0].
            images = images.astype(np.float32)
            images = np.multiply(images, 1.0 / 255.0)
        self._images = images
        self._labels = labels
        self._epochs_completed = 0
        self._index_in_epoch = 0

    @property
    def images(self):
        return self._images

    @property
    def labels(self):
        return self._labels

    @property
    def num_examples(self):
        return self._num_examples

    @property
    def epochs_completed(self):
        return self._epochs_completed

    def next_batch(self, batch_size, fake_data=False):
        """Return the next `batch_size` examples from this data set."""
        if fake_data:
            fake_image = [1.0 for _ in xrange(40*24)]
            fake_label = 0
            return [fake_image for _ in xrange(batch_size)], [
                fake_label for _ in xrange(batch_size)]
        start = self._index_in_epoch
        self._index_in_epoch += batch_size
        if self._index_in_epoch > self._num_examples:
            # Finished epoch
            self._epochs_completed += 1
            # Shuffle the data
            perm = np.arange(self._num_examples)
            np.random.shuffle(perm)
            self._images = self._images[perm]
            self._labels = self._labels[perm]
            # Start next epoch
            start = 0
            self._index_in_epoch = batch_size
            assert batch_size <= self._num_examples
        end = self._index_in_epoch
        return self._images[start:end], self._labels[start:end]


def extractLabel(label):


    label=np.array(label)
    # label.flatten()
    label=label.reshape(2500,5)

    return label

def extractTraining(data):

    data=np.array(data)

    data=data.reshape(2500,40,24,1)

    return data


def extractTesting(test):
    test=np.array(test)
    print test.size
    test=test.reshape(testSize,40,24,1)

    return test

def extractTestLabel(testLabel):

    testLabel=np.array(testLabel)

    testLabel=testLabel.reshape(testSize,5)

    return testLabel


def read_data_sets(train_dir,data,label,test,testLabel,fake_data=False, one_hot=False):
    class DataSets(object):
        pass
    data_sets = DataSets()
    if fake_data:
        data_sets.train = DataSet([], [], fake_data=True)
        data_sets.validation = DataSet([], [], fake_data=True)
        data_sets.test = DataSet([], [], fake_data=True)
        return data_sets
    TRAIN_IMAGES = 'train-images-idx3-ubyte.gz'
    TRAIN_LABELS = 'train-labels-idx1-ubyte.gz'
    TEST_IMAGES = 't10k-images-idx3-ubyte.gz'
    TEST_LABELS = 't10k-labels-idx1-ubyte.gz'
    VALIDATION_SIZE = 50
    # local_file = maybe_download(TRAIN_IMAGES, train_dir)
    train_images = extractTraining(data)
    # local_file = maybe_download(TRAIN_LABELS, train_dir)
    train_labels = extractLabel(label)
    # local_file = maybe_download(TEST_IMAGES, train_dir)
    test_images = extractTesting(test)
    # local_file = maybe_download(TEST_LABELS, train_dir)
    test_labels = extractTestLabel(testLabel)

    validation_images = train_images[:VALIDATION_SIZE]
    validation_labels = train_labels[:VALIDATION_SIZE]
    train_images = train_images[VALIDATION_SIZE:]
    train_labels = train_labels[VALIDATION_SIZE:]
    data_sets.train = DataSet(train_images, train_labels)
    data_sets.validation = DataSet(validation_images, validation_labels)
    data_sets.test = DataSet(test_images, test_labels)
    return data_sets



data=[]
label=[]

test=[]
testLabel=[]

with open("data5secondwindows_40_24_AIM3_sampled.csv") as f:
    f_csv=csv.reader(f)

    headers=next(f_csv)

    counter=0
    for row in f_csv:
        counter+=1

        utils.transferNumToBinaryArray(float(row[0]),5,label)

        for element in row[1:]:
            data.append(abs(float(element)))
        if counter>=2500:
            break


with open("data5secondwindows_40_24_AIM3_all.csv") as f:
    f_csv=csv.reader(f)

    headers=next(f_csv)

    counter=0
    for row in f_csv:
        counter+=1

        utils.transferNumToBinaryArray(float(row[0]),5,testLabel)

        for element in row[1:]:
            test.append(abs(float(element)))
        if counter>=testSize:
            break

mnist = read_data_sets("1",data=data,label=label,test=test,testLabel=testLabel)








sess = tf.InteractiveSession()

x = tf.placeholder(tf.float32, shape=[None, 40*24])
y_ = tf.placeholder(tf.float32, shape=[None, 5])


def weight_variable(shape):
  initial = tf.truncated_normal(shape, stddev=0.1)
  return tf.Variable(initial)

def bias_variable(shape):
  initial = tf.constant(0.1, shape=shape)
  return tf.Variable(initial)

def conv2d(x, W):
  return tf.nn.conv2d(x, W, strides=[1, 1, 1, 1], padding='SAME')

def max_pool_2x2(x):
  return tf.nn.max_pool(x, ksize=[1, 2, 2, 1],
                        strides=[1, 2, 2, 1], padding='SAME')


W_conv1 = weight_variable([8, 7, 1, 5])
b_conv1 = bias_variable([5])

x_image = tf.reshape(x, [-1,40,24,1])
h_conv1 = tf.nn.relu(conv2d(x_image, W_conv1) + b_conv1)
# h_conv1 = max_pool_2x2(h_conv1)

W_conv2 = weight_variable([5, 5, 5, 10])
b_conv2 = bias_variable([10])

h_conv2 = tf.nn.relu(conv2d(h_conv1, W_conv2) + b_conv2)
# h_conv2 = max_pool_2x2(h_conv2)

W_fc1 = weight_variable([40*24 * 10, 1024])
b_fc1 = bias_variable([1024])
#
# h_pool2_flat = tf.reshape(h_conv2, [-1, 40*12*64])
# h_fc1 = tf.nn.relu(tf.matmul(h_pool2_flat, W_fc1) + b_fc1)
#
# keep_prob = tf.placeholder(tf.float32)
# h_fc1_drop = tf.nn.dropout(h_fc1, keep_prob)

_dropout=tf.placeholder(tf.float32)

dense1 = tf.reshape(h_conv2, [-1, W_fc1.get_shape().as_list()[0]]) # Reshape conv2 output to fit dense layer input
dense1 = tf.nn.relu(tf.add(tf.matmul(dense1, W_fc1), b_fc1)) # Relu activation
dense1 = tf.nn.dropout(dense1, _dropout) # Apply Dropout

W_fc2 = weight_variable([1024, 250])
b_fc2 = bias_variable([250])



dense2 = tf.nn.relu(tf.add(tf.matmul(dense1, W_fc2), b_fc2)) # Relu activation
dense2 = tf.nn.dropout(dense2, _dropout) # Apply Dropout

#
#
W_fc3 = weight_variable([250, 5])
b_fc3 = bias_variable([5])

y_conv=tf.nn.softmax(tf.matmul(dense2, W_fc3) + b_fc3)

# cross_entropy = -tf.reduce_sum(y_*tf.log(y_conv))
cross_entropy = -tf.reduce_sum(y_*tf.log(tf.clip_by_value(y_conv,1e-10,1.0)))
train_step = tf.train.AdamOptimizer(1e-4).minimize(cross_entropy)
correct_prediction = tf.equal(tf.argmax(y_conv,1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
sess.run(tf.initialize_all_variables())
for i in range(10000):
  batch = mnist.train.next_batch(50)
  if i%100 == 0:
    train_accuracy = accuracy.eval(feed_dict={
        x:batch[0], y_: batch[1], _dropout: 1.0})
    print("step %d, training accuracy %g"%(i, train_accuracy))
  train_step.run(feed_dict={x: batch[0], y_: batch[1], _dropout: 0.5})
  print ("step"+str(i))


# w_con1 = W_conv1.eval(sess)
#
# w_con1_=np.array(w_con1)
#
# w_con1_=w_con1_.flatten()
#
# file=open("weight.txt","w+")
#
# for i in range(0,len(w_con1_)):
#     file.write(str(w_con1_[i])+"\n")
#
# file.close()


# print("test accuracy %g"%accuracy.eval(feed_dict={
#     x: mnist.test.images, y_: mnist.test.labels, _dropout: 1.0}))




file=open("output.txt","w+")
for i in range(0,10):

    test2=[]
    with open("data5secondwindows_40_24_AIM3_all.csv") as f:
        f_csv2=csv.reader(f)

        headers=next(f_csv2)

        counter=0
        for row in f_csv2:

            if counter>=i*5000 and counter<i*5000+5000:

                for element in row[1:]:
                    test2.append(abs(float(element)))
                # if counter>=testSize:
                #     break
            counter+=1
    # test2=mnist.test.images[5000*i:5000*i+5000]

    t=np.array(test2)
    t=t.reshape(testSize,960)


    # a=(sess.run(tf.argmax(y_conv,1),feed_dict={x: t, _dropout: 1.0}))

    a=tf.argmax(y_conv,1).eval(feed_dict={x: t, _dropout: 1.0})

    for j in range(0,len(a)):
        file.write(str(a[j])+"\n")

    print a
    a=[]
    test2=[]
    print str(i)+"th test"
    gc.collect()

file.close()