from sklearn.utils import shuffle
Xn, y = shuffle(Xn, y)

(X_train, X_test,  y_train, y_test) = cv.train_test_split(Xn, y, test_size=.35, random_state=10)
