;; Copyright 2010-2018 Ben Lambert

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;;     http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

(in-package :optimization)

(defun iterative-scaling (&key objective-function feature-expectation-function model data (iterations 10))
  "Run the iterative scaling algorithm.  This requires an objective function, an initial array of parameter values,
   a feature expectation function, model, data, and iterations.  Convergence is *not* detected automatically."
  (let* ((x (parameters model))
	 (f 0.0d0))
    (dotimes (i iterations)
      (format t "iteration: ~S~%" i)
      (setf f (funcall objective-function x model data))
      (format t "Objective function value = ~10,5F~%" f)
      (let ((expected-counts (funcall feature-expectation-function model data)))
	(is-param-update model expected-counts)))))

(defun is-param-update (model model-predicted-feature-counts)
    "Itertive scaling parmeter update.  The update rule is: 1/M * log (data-exp/model-exp)  .... where M=1??? (for boolean features?)"
    (map-into model-predicted-feature-counts '/ (feature-counts model) model-predicted-feature-counts)
    (map-into model-predicted-feature-counts (lambda (x) (if (> x 0)
							     (log x)
							     0.0d0))
	      model-predicted-feature-counts)
    ;; do the update here
    (map-into (parameters model) '+ (parameters model) model-predicted-feature-counts))

;;;;TODO: The following, the step size, is needed for improved iterative scaling?
(defun get-approximate-step-size-vector (model data)
  "???? Not implemented... but this is important for efficiency?"
  (declare (ignore model data))
  (error "Not implemented."))
