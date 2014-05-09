# Machine Learning

## Resources

* http://scikit-learn.org/stable/tutorial/basic/tutorial.html

## Terminology

* samples: X
* feautres: Y
* target: the trouth
* fit: Learn from the model
* data.shape -> (n_samples, n_features)
* Supervised learning consists in learning the link between two datasets: the observed data X and an external variable y that we are trying to predict, usually called target or labels. Most often, y is a 1D array of length n_samples.


## Algorithms

* Support Vector Machine (SVM):
  - supervised learning used for classification and regression analysis
  - predicts two possible classes, making it a non-probabilistic binary linear classifier
  - they try to find a combination of samples to build a plane maximizing the margin between the two classes.
  - SVMs can be used in regression –SVR (Support Vector Regression)–, or in classification –SVC (Support Vector Classification).
  - Classes are not always linearly separable in feature space. The solution is to build a decision function that is not linear but may be polynomial instead.
  - Nonetheless, **scaling should be a mandatory preprocessing step when using SVC, especially with a RBF kernel**.
* K-Nearest neighbors classifier (KNN):
  - non-parametric method for classification and regression,[1] that predicts objects based on the k closest training examples in the feature space
  - an object is classified by a majority vote of its neighbors, with the object being assigned to the class most common amongst its k nearest neighbors
  - used for regression, by simply assigning the property value for the object to be the average of the values of its k nearest neighbors
  - from sklearn.neighbors import KNeighborsClassifier
* LinearRegression:
  - in it’s simplest form, fits a linear model to the data set by adjusting a set of parameters in order to make the sum of the squared residuals of the model as small as possible.
  - from sklearn import linear_model
* Decision Tree:
  - used to map observations about an item to conclusions about the items target value
  - More descriptive names for such tree models are classification trees or regression trees. In these tree structures, leaves represent class labels and branches represent conjunctions of features that lead to those class labels.
* Randomized Tree:
  -
* Principle Components Analysis:
  - reduce the number of dimensions to two dimeinsions _n_components. Then fit_transform the data to project it into the two dimensions. Plotting it can then give some early insights into the data set
  - from sklearn.decomposition import RandomizedPCA



## Techniques, Practices and Problems

* Shrinkage:
  - If there are few data points per dimension, noise in the observations induces high variance.
* Overfitting:
  - Capturing in the fitted parameters noise that prevents the model to generalize to new data is called overfitting.
  - prevents from predicting the future
  - can be detected with cross-validation
* Regularization:
  - The bias introduced by the ridge regression is called a regularization.
* Multiclass classification:
  - If you have several classes to predict, an option often used is to fit one-versus-all classifiers and then use a voting heuristic for the final decision.
* Curse of dimensionality
  - The common theme of these problems is that when the dimensionality increases, the volume of the space increases so fast that the available data becomes sparse. This sparsity is problematic for any method that requires statistical significance. In order to obtain a statistically sound and reliable result, the amount of data needed to support the result often grows exponentially with the dimensionality. Also organizing and searching data often relies on detecting areas where objects form groups with similar properties; in high dimensional data however all objects appear to be sparse and dissimilar in many ways which prevents common data organization strategies from being efficient.
  - ffectiveness of dimension reduction methods such as principal component analysis in many situations
* Overfitting:
  - overfitting occurs when a statistical model describes random error or noise instead of the underlying relationship. Overfitting generally occurs when a model is excessively complex, such as having too many parameters relative to the number of observations. A model which has been overfit will generally have poor predictive performance, as it can exaggerate minor fluctuations in the data.
  - Overfitting occurs when a model begins to memorize training data rather than learning to generalize from trend
  - In order to avoid overfitting, it is necessary to use additional techniques (e.g. cross-validation, regularization, early stopping, pruning, Bayesian priors on parameters or model comparison), that can indicate when further training is not resulting in better generalization.
- Whenever the test data score is not as good as the train score the model is overfitting
Whenever the train score is not close to 100% accuracy the model is underfitting
Ideally we want to neither overfit nor underfit: test_score ~= train_score ~= 1.0.
* Regularization:
  - a process of introducing additional information in order to solve an ill-posed problem or to prevent overfitting. This information is usually of the form of a penalty for complexity, such as restrictions for smoothness or bounds on the vector space norm.
* Occams Razor:
  -  It states that among competing hypotheses, the hypothesis with the fewest assumptions should be selected.
  - The application of the principle often shifts the burden of proof in a discussion.[a] The razor states that one should proceed to simpler theories until simplicity can be traded for greater explanatory power. The simplest available theory need not be most accurate.
 - guide scientists in the development of theoretical models
* Cross Validation:
 - split data set into a training and a test set.
 - from sklearn.cross_validation import train_test_split
 - X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.25, random_state=0)
 - Cross Validation is a procedure to repeat the train / test split several times to as to get a more accurate estimate of the real test score by averaging the values found of the individual runs.
    from sklearn.cross_validation import cross_val_score

    svc = SVC(kernel="rbf", C=1, gamma=0.001)
    cv = ShuffleSplit(n_samples, n_iter=100, test_size=0.1,
        random_state=0)

    test_scores = cross_val_score(svc, X, y, cv=cv, n_jobs=8)
    test_scores
* Grid Search
  - Cross Validation makes it possible to evaluate the performance of a model class and its hyper parameters on the task at hand.
A natural extension is thus to run CV several times for various values of the parameters so as to find the best. For instance, let us fix the SVC parameter to C=10 and compute the cross validated test score for various values of gamma:
  - from sklear.grid_search import GridSearchCV (or the new one which tests the parameters in randomized order)
  - used to compute / fit our estimator for an entire grid of parameters
  - grid.best_params_, grid.best_score_
  -  Doing this procedure several for each parameter combination is tedious, hence it is possible to automate the procedure by computing the test score for all possible combinations of parameters using the GridSearchCV helper

What to do against overfitting?
Try to get rid of noisy features using feature selection methods (or better let the model do it if the regularization is able to do so: for instance l1 penalized linear models)
Try to tune parameters to add more regularization:
Smaller values of C for SVM
Larger values of alpha for penalized linear models
Restrict to shallower trees (decision stumps) and lower numbers of samples per leafs for tree-based models
Try simpler model families such as penalized linear models (e.g. Linear SVM, Logistic Regression, Naive Bayes)
Try the ensemble strategies that average several independently trained models (e.g. bagging or blending ensembles): average the predictions of independently trained models
Collect more labeled samples if the learning curves of the test score has a non-zero slope on the right hand side.

What to do against underfitting?
Give more freedom to the model by relaxing some parameters that act as regularizers:
Larger values of C for SVM
Smaller values of alpha for penalized linear models
Allow deeper trees and lower numbers of samples per leafs for tree-based models
Try more complex / expressive model families:
Non linear kernel SVMs,
Ensemble of Decision Trees...
Construct new features:
bi-gram frequencies for text classifications
feature cross-products (possibly using the hashing trick)
unsupervised features extraction (e.g. triangle k-means, auto-encoders...)
non-linear kernel approximations + linear SVM instead of simple linear SVM

Final Model Assessment:
For dataset sampled over time, it is highly recommended to use a temporal split for the Development / Evaluation split: for instance, if you have collected data over the 2008-2013 period, you can:
use 2008-2011 for development (grid search optimal parameters and model class),
2012-2013 for evaluation (compute the test score of the best model parameters).






## Ensemble learning algorithms:
  - an ensemble is a technique for combining many weak learners in an attempt to produce a strong learner (usually using the same base learner)
  - Basically, we compensate poor learning algorithms by performing a lot of extra computation.

 Bootstrap aggregating
Bootstrap aggregating, often abbreviated as bagging, involves having each model in the ensemble vote with equal weight. In order to promote model variance, bagging trains each model in the ensemble using a randomly drawn subset of the training set. As an example, the random forest algorithm combines random decision trees with bagging to achieve very high classification accuracy.[11] An interesting application of bagging in unsupervised learning is provided here.[12]
Boosting
 Boosting (meta-algorithm)
Boosting involves incrementally building an ensemble by training each new model instance to emphasize the training instances that previous models mis-classified. In some cases, boosting has been shown to yield better accuracy than bagging, but it also tends to be more likely to over-fit the training data. By far, the most common implementation of Boosting is Adaboost, although some newer algorithms are reported to achieve better results[citation


## Algorithm types

Machine learning algorithms can be organized into a taxonomy based on the desired outcome of the algorithm or the type of input available during training the machine[citation needed].
Supervised learning algorithms are trained on labelled examples, i.e., input where the desired output is known. The supervised learning algorithm attempts to generalise a function or mapping from inputs to outputs which can then be used to speculatively generate an output for previously unseen inputs.
Unsupervised learning algorithms operate on unlabelled examples, i.e., input where the desired output is unknown. Here the objective is to discover structure in the data (e.g. through a cluster analysis), not to generalise a mapping from inputs to outputs.
Semi-supervised learning combines both labeled and unlabelled examples to generate an appropriate function or classifier.
Transduction, or transductive inference, tries to predict new outputs on specific and fixed (test) cases from observed, specific (training) cases.
Reinforcement learning is concerned with how intelligent agents ought to act in an environment to maximise some notion of reward. The agent executes actions which cause the observable state of the environment to change. Through a sequence of actions, the agent attempts to gather knowledge about how the environment responds to its actions, and attempts to synthesise a sequence of actions that maximises a cumulative reward.
Learning to learn learns its own inductive bias based on previous experience.
Developmental learning, elaborated for Robot learning, generates its own sequences (also called curriculum) of learning situations to cumulatively acquire repertoires of novel skills through autonomous self-exploration and social interaction with human teachers, and using guidance mechanisms such as active learning, maturation, motor synergies, and imitation.




